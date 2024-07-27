import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct CreateConsolidatedReportView: View {
    @State private var testResults: [TestResult] = []
    @State private var selectedTestResults: Set<TestResult> = []
    @State private var isGeneratingReport = false
    @State private var progress: Double = 0.0

    var body: some View {
        VStack {
            List {
                ForEach(testResults, id: \.testID) { testResult in
                    HStack {
                        TestResultRowView(testResult: testResult)
                        Spacer()
                        if selectedTestResults.contains(testResult) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .onTapGesture {
                        if selectedTestResults.contains(testResult) {
                            selectedTestResults.remove(testResult)
                        } else {
                            selectedTestResults.insert(testResult)
                        }
                    }
                }
            }

            HStack {
                Button(action: selectAll) {
                    Text("Select All")
                }
                .padding()
                
                Button(action: unselectAll) {
                    Text("Unselect All")
                }
                .padding()
            }
            
            Button(action: generateConsolidatedReport) {
                Text("Generate Report")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            if isGeneratingReport {
                ProgressView(value: progress, total: Double(selectedTestResults.count))
                    .padding()
            }
        }
        .onAppear {
            fetchTestResults()
        }
    }

    private func fetchTestResults() {
        guard let user = Auth.auth().currentUser else { return }

        let db = Firestore.firestore()
        db.collection("testResults").document(user.uid).collection("results")
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching test results: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }
                self.testResults = documents.compactMap { try? $0.data(as: TestResult.self) }
            }
    }

    private func selectAll() {
        selectedTestResults = Set(testResults)
    }

    private func unselectAll() {
        selectedTestResults.removeAll()
    }

    private func generateConsolidatedReport() {
        guard !selectedTestResults.isEmpty else { return }

        isGeneratingReport = true
        progress = 0.0

        let dispatchGroup = DispatchGroup()

        var allMessages: [TakeTestMessage] = []

        for testResult in selectedTestResults {
            dispatchGroup.enter()
            fetchMessages(for: testResult) { messages in
                allMessages.append(contentsOf: messages)
                self.progress += 1.0
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.createConsolidatedReport(with: allMessages)
        }
    }

    private func fetchMessages(for testResult: TestResult, completion: @escaping ([TakeTestMessage]) -> Void) {
        guard let user = Auth.auth().currentUser else { return }

        let db = Firestore.firestore()
        let resultId = testResult.testID
        let messagesCollection = db.collection("testResults")
                                    .document(user.uid)
                                    .collection("results")
                                    .document(resultId)
                                    .collection("messages")

        messagesCollection
            .order(by: "timestamp")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No documents found")
                    completion([])
                    return
                }

                let messages = documents.compactMap { try? $0.data(as: TakeTestMessage.self) }
                completion(messages)
            }
    }

    private func createConsolidatedReport(with messages: [TakeTestMessage]) {
        // Call OpenAI API to generate consolidated report
        // Save the report to Firestore
        guard let user = Auth.auth().currentUser else { return }

        let db = Firestore.firestore()
        let newReport = ConsolidatedReport(
            reportID: UUID().uuidString,
            date: Date(),
            content: "Generated Report Content",
            messages: messages
        )

        do {
            try db.collection("consolidatedReports").document(user.uid).collection("reports").document(newReport.reportID).setData(from: newReport) { error in
                if let error = error {
                    print("Error saving consolidated report: \(error.localizedDescription)")
                    return
                }

                self.isGeneratingReport = false
                // Dismiss view on success
            }
        } catch {
            print("Error creating consolidated report: \(error.localizedDescription)")
            self.isGeneratingReport = false
        }
    }
}
