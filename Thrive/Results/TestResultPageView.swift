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

                List(testResults) { testResult in
                    TestResultRowView(testResult: testResult)
                        .onTapGesture {
                            fetchMessages(for: testResult)
                        }
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
        let resultId = testResult.id ?? ""
        let messagesCollection = db.collection("testResults").document(user.uid).collection("results").document(resultId).collection("messages")

        messagesCollection
            .order(by: "timestamp")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }
                self.selectedMessages = documents.compactMap { try? $0.data(as: ChatMessage.self) }
                self.showChatDetail = true
            }
    }
}
