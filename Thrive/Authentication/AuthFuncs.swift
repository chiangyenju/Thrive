import Firebase

func fetchUserDetails(uid: String, completion: @escaping (AppUser?) -> Void) {
    let db = Firestore.firestore()
    db.collection("users").document(uid).getDocument { (document, error) in
        if let document = document, document.exists {
            let data = document.data()
            
            // Retrieve values from Firestore data
            let username = data?["username"] as? String ?? "Anonymous"
            let profilePicURL = data?["profilePicURL"] as? String ?? ""
            let email = data?["email"] as? String ?? ""
            let createdAtTimestamp = data?["createdAt"] as? Timestamp
            let createdAt = createdAtTimestamp?.dateValue() ?? Date()
            let followersCount = data?["followersCount"] as? Int ?? 0
            let followingCount = data?["followingCount"] as? Int ?? 0
            let followers = data?["followers"] as? [String] ?? []
            let following = data?["following"] as? [String] ?? []
            
            // Create an AppUser instance
            let appUser = AppUser(
//                id: document.documentID,
                userID: uid,
                username: username,
                profilePicURL: profilePicURL,
                email: email,
                createdAt: createdAt,
                followersCount: followersCount,
                followingCount: followingCount,
                followers: followers,
                following: following
            )
            completion(appUser)
        } else {
            print("User document does not exist")
            completion(nil)
        }
    }
}
