import SwiftUI
import Firebase
import Combine

class FollowingListViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var followingUsers: [AppUser] = []
    @Published var filteredUsers: [AppUser] = []

    private var db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    var currentUserID: String? {
        Auth.auth().currentUser?.uid
    }

    init() {
        self.$searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                self?.fetchUsers(matching: searchText)
            }
            .store(in: &cancellables)
    }

    func fetchFollowingUsers() {
        guard let currentUserID = currentUserID else { return }

        db.collection("users").document(currentUserID).getDocument { [weak self] (document, error) in
            guard let self = self, let document = document, document.exists else {
                print("Error fetching current user document: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let following = document.data()?["following"] as? [String] ?? []

            guard !following.isEmpty else {
                self.followingUsers = []
                return
            }

            self.db.collection("users").whereField("userID", in: following).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching following users: \(error.localizedDescription)")
                    return
                }

                if let querySnapshot = querySnapshot {
                    self.followingUsers = querySnapshot.documents.compactMap { document -> AppUser? in
                        let data = document.data()
                        let id = document.documentID
                        let userID = data["userID"] as? String ?? ""
                        let username = data["username"] as? String ?? "Anonymous"
                        let profilePicURL = data["profilePicURL"] as? String ?? ""
                        let email = data["email"] as? String ?? ""
                        let createdAtTimestamp = data["createdAt"] as? Timestamp
                        let createdAt = createdAtTimestamp?.dateValue() ?? Date()
                        let followersCount = data["followersCount"] as? Int ?? 0
                        let followingCount = data["followingCount"] as? Int ?? 0
                        let followers = data["followers"] as? [String] ?? []
                        let following = data["following"] as? [String] ?? []

                        return AppUser(id: id, userID: userID, username: username, profilePicURL: profilePicURL, email: email, createdAt: createdAt, followersCount: followersCount, followingCount: followingCount, followers: followers, following: following)
                    }
                }
            }
        }
    }

    func fetchUsers(matching searchText: String) {
        guard !searchText.isEmpty else {
            self.filteredUsers = []
            return
        }

        db.collection("users")
            .whereField("username", isGreaterThanOrEqualTo: searchText)
            .whereField("username", isLessThanOrEqualTo: searchText + "\u{f8ff}")
            .getDocuments { [weak self] (querySnapshot, error) in
                guard let self = self else { return }

                if let error = error {
                    print("Error fetching users: \(error.localizedDescription)")
                    return
                }

                if let querySnapshot = querySnapshot {
                    self.filteredUsers = querySnapshot.documents.compactMap { document -> AppUser? in
                        let data = document.data()
                        let id = document.documentID
                        let userID = data["userID"] as? String ?? ""
                        let username = data["username"] as? String ?? "Anonymous"
                        let profilePicURL = data["profilePicURL"] as? String ?? ""
                        let email = data["email"] as? String ?? ""
                        let createdAtTimestamp = data["createdAt"] as? Timestamp
                        let createdAt = createdAtTimestamp?.dateValue() ?? Date()
                        let followersCount = data["followersCount"] as? Int ?? 0
                        let followingCount = data["followingCount"] as? Int ?? 0
                        let followers = data["followers"] as? [String] ?? []
                        let following = data["following"] as? [String] ?? []

                        return AppUser(id: id, userID: userID, username: username, profilePicURL: profilePicURL, email: email, createdAt: createdAt, followersCount: followersCount, followingCount: followingCount, followers: followers, following: following)
                    }
                }
            }
    }

    func toggleFollow(user: AppUser) {
        guard let currentUserID = currentUserID, let userID = user.id else { return }

        let userDoc = db.collection("users").document(userID)
        let currentUserDoc = db.collection("users").document(currentUserID)

        userDoc.getDocument { [weak self] (document, error) in
            guard let self = self, let document = document, document.exists else {
                print("Error fetching user document: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            var followers = document.data()?["followers"] as? [String] ?? []
            var followersCount = document.data()?["followersCount"] as? Int ?? 0

            let isFollowing = followers.contains(currentUserID)

            if isFollowing {
                // Unfollow
                followers.removeAll { $0 == currentUserID }
                followersCount -= 1

                userDoc.updateData([
                    "followers": followers,
                    "followersCount": followersCount
                ]) { error in
                    if let error = error {
                        print("Error updating followers: \(error.localizedDescription)")
                    } else {
                        self.updateFollowing(currentUserDoc: currentUserDoc, userID: userID, remove: true)
                    }
                }
            } else {
                // Follow
                followers.append(currentUserID)
                followersCount += 1

                userDoc.updateData([
                    "followers": followers,
                    "followersCount": followersCount
                ]) { error in
                    if let error = error {
                        print("Error updating followers: \(error.localizedDescription)")
                    } else {
                        self.updateFollowing(currentUserDoc: currentUserDoc, userID: userID, remove: false)
                    }
                }
            }
        }
    }

    private func updateFollowing(currentUserDoc: DocumentReference, userID: String, remove: Bool) {
        currentUserDoc.getDocument { [weak self] (document, error) in
            guard let self = self, let document = document, document.exists else {
                print("Error fetching current user document: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            var following = document.data()?["following"] as? [String] ?? []
            var followingCount = document.data()?["followingCount"] as? Int ?? 0

            if remove {
                following.removeAll { $0 == userID }
                followingCount -= 1
            } else {
                following.append(userID)
                followingCount += 1
            }

            currentUserDoc.updateData([
                "following": following,
                "followingCount": followingCount
            ]) { error in
                if let error = error {
                    print("Error updating following: \(error.localizedDescription)")
                } else {
                    self.fetchFollowingUsers()
                }
            }
        }
    }
}
