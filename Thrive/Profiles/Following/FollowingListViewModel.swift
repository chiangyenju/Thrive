import SwiftUI
import Firebase
import Combine

class FollowingListViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var followingUsers: [AppUser] = []
    @Published var filteredUsers: [AppUser] = []
    
    private var db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    private var currentUserID: String? {
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
        guard let currentUserID = currentUserID else { return }
        
        let userDoc = db.collection("users").document(user.id ?? "")
        let currentUserDoc = db.collection("users").document(currentUserID)
        
        if user.followers.contains(currentUserID) {
            // Unfollow
            userDoc.updateData([
                "followers": FieldValue.arrayRemove([currentUserID]),
                "followersCount": FieldValue.increment(Int64(-1))
            ])
            currentUserDoc.updateData([
                "following": FieldValue.arrayRemove([user.userID]),
                "followingCount": FieldValue.increment(Int64(-1))
            ])
        } else {
            // Follow
            userDoc.updateData([
                "followers": FieldValue.arrayUnion([currentUserID]),
                "followersCount": FieldValue.increment(Int64(1))
            ])
            currentUserDoc.updateData([
                "following": FieldValue.arrayUnion([user.userID]),
                "followingCount": FieldValue.increment(Int64(1))
            ])
        }
        
        // Update local data
        if let index = self.filteredUsers.firstIndex(where: { $0.id == user.id }) {
            var updatedUser = self.filteredUsers[index]
            if updatedUser.followers.contains(currentUserID) {
                updatedUser.followers.removeAll { $0 == currentUserID }
                updatedUser.followersCount -= 1
            } else {
                updatedUser.followers.append(currentUserID)
                updatedUser.followersCount += 1
            }
            self.filteredUsers[index] = updatedUser
        }
    }
}
