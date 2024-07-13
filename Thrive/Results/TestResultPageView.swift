import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct TestResultPageView: View {
    @State private var testResults: [TestResult] = []
    @State private var selectedMessages: [ChatMessage] = []
    @State private var showChatDetail = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Test Results")
                    .font(Font.custom("LexendDeca-ExtraBold", size: 24))
                    .padding([.top, .leading], 20)

                List {
                    ForEach(testResults, id: \.testID) { testResult in
                        TestResultRowView(testResult: testResult)
                            .onTapGesture {
                                print("Tapped on test result: \(testResult)")
                                fetchMessages(for: testResult)
                            }
                    }
                    .onDelete(perform: deleteTestResult) // Swipe to delete action
                }
                .listStyle(PlainListStyle())
                .onAppear {
                    fetchTestResults()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(
                NavigationLink(destination: ChatDetailView(messages: selectedMessages), isActive: $showChatDetail) {
                    EmptyView()
                }
            )
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
}
