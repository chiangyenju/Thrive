import SwiftUI
import FirebaseFirestore

struct ResultsPageView: View {
    @State private var interactions: [Interaction] = []
    @StateObject private var authService = AuthService()

    var body: some View {
        VStack {
            List(interactions) { interaction in
                VStack(alignment: .leading) {
                    Text(interaction.message)
                        .fontWeight(.bold)
                    Text(interaction.response)
                }
            }
        }
        .onAppear {
            fetchInteractions()
        }
        .navigationTitle("Results")
    }

    func fetchInteractions() {
        guard let user = authService.user else { return }
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).collection("interactions")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching interactions: \(error.localizedDescription)")
                    return
                }
                self.interactions = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: Interaction.self)
                } ?? []
            }
    }
}

struct Interaction: Identifiable, Codable {
    @DocumentID var id: String?
    let message: String
    let response: String
    let timestamp: Timestamp
}
