import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class FollowingListViewModel: ObservableObject {
    @Published var filteredUsers: [AppUser] = []
    private var allUsers: [AppUser] = []
    private var db = Firestore.firestore()
    private var cancellables: Set<AnyCancellable> = []

    func fetchFollowingUsers() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(currentUserID).getDocument { [weak self] document, error in
            if let error = error {
                print("Error fetching following users: \(error.localizedDescription)")
                return
            }
            guard let data = document?.data(), let following = data["following"] as? [String] else { return }

            self?.fetchUsers(userIDs: following)
        }
    }

    private func fetchUsers(userIDs: [String]) {
        let userRefs = userIDs.map { db.collection("users").document($0) }

        Publishers.MergeMany(userRefs.map { $0.getDocumentPublisher() })
            .collect()
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error fetching users: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] documents in
                self?.allUsers = documents.compactMap { document in
                    try? document.data(as: AppUser.self)
                }
                self?.filteredUsers = self?.allUsers ?? []
            }
            .store(in: &cancellables)
    }

    func searchUsers(by text: String) {
        if text.isEmpty {
            filteredUsers = allUsers
        } else {
            filteredUsers = allUsers.filter { $0.username.lowercased().contains(text.lowercased()) }
        }
    }
}

extension DocumentReference {
    func getDocumentPublisher() -> AnyPublisher<DocumentSnapshot, Error> {
        Future<DocumentSnapshot, Error> { promise in
            self.getDocument { document, error in
                if let document = document {
                    promise(.success(document))
                } else if let error = error {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
