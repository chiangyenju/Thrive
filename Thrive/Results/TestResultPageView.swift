import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct TestResultPageView: View {
    @State private var testResults: [TestResult] = []
    @State private var consolidatedReports: [ConsolidatedReport] = []
    @State private var selectedMessages: [ChatMessage] = []
    @State private var showChatDetail = false
    @State private var selectedTab = 0

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Picker("Select Tab", selection: $selectedTab) {
                    Text("Test Results").tag(0)
                    Text("Consolidated Reports").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if selectedTab == 0 {
                    testResultsView
                } else {
                    consolidatedReportsView
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(
                NavigationLink(destination: ChatDetailView(messages: selectedMessages), isActive: $showChatDetail) {
                    EmptyView()
                }
            )
            .onAppear {
                fetchTestResults()
                fetchConsolidatedReports()
            }
        }
    }

    private var testResultsView: some View {
        List {
            ForEach(testResults, id: \.testID) { testResult in
                TestResultRowView(testResult: testResult)
                    .onTapGesture {
                        fetchMessages(for: testResult)
                    }
            }
            .onDelete(perform: deleteTestResult) // Swipe to delete action
        }
        .listStyle(PlainListStyle())
    }

    private var consolidatedReportsView: some View {
        VStack {
            List {
                ForEach(consolidatedReports, id: \.reportID) { report in
                    ConsolidatedReportRowView(report: report)
                        .onTapGesture {
                            // Handle tap on consolidated report
                        }
                }
                .onDelete(perform: deleteConsolidatedReport)
            }
            .listStyle(PlainListStyle())

            Button(action: {
                // Navigate to create new consolidated report view
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Create Consolidated Report")
                }
            }
            .padding()
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

    private func fetchConsolidatedReports() {
        guard let user = Auth.auth().currentUser else { return }

        let db = Firestore.firestore()
        db.collection("consolidatedReports").document(user.uid).collection("reports")
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching consolidated reports: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }
                self.consolidatedReports = documents.compactMap { try? $0.data(as: ConsolidatedReport.self) }
            }
    }

    private func fetchMessages(for testResult: TestResult) {
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
                    return
                }

                self.selectedMessages = documents.compactMap { try? $0.data(as: ChatMessage.self) }
                self.showChatDetail = true // Ensure ChatDetailView is shown when messages are fetched
            }
    }

    private func deleteTestResult(at offsets: IndexSet) {
        guard let user = Auth.auth().currentUser else {
            print("User is not authenticated.")
            return
        }

        let db = Firestore.firestore()
        let batch = db.batch()

        // Delete each selected test result document
        offsets.forEach { index in
            let resultToDelete = testResults[index]
            let resultRef = db.collection("testResults").document(user.uid).collection("results").document(resultToDelete.testID)

            batch.deleteDocument(resultRef)

            // Optionally, remove locally
            testResults.remove(at: index)
        }

        // Commit the batch delete
        batch.commit { error in
            if let error = error {
                print("Error deleting test result: \(error.localizedDescription)")
                // Optionally handle the error
            } else {
                print("Test result deleted successfully.")
            }
        }
    }

    private func deleteConsolidatedReport(at offsets: IndexSet) {
        guard let user = Auth.auth().currentUser else {
            print("User is not authenticated.")
            return
        }

        let db = Firestore.firestore()
        let batch = db.batch()

        // Delete each selected consolidated report document
        offsets.forEach { index in
            let reportToDelete = consolidatedReports[index]
            let reportRef = db.collection("consolidatedReports").document(user.uid).collection("reports").document(reportToDelete.reportID)

            batch.deleteDocument(reportRef)

            // Optionally, remove locally
            consolidatedReports.remove(at: index)
        }

        // Commit the batch delete
        batch.commit { error in
            if let error = error {
                print("Error deleting consolidated report: \(error.localizedDescription)")
                // Optionally handle the error
            } else {
                print("Consolidated report deleted successfully.")
            }
        }
    }
}
