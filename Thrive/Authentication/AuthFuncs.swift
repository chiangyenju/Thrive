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
            
            // Create an AppUser instance
            let appUser = AppUser(userID: uid, username: username, profilePicURL: profilePicURL, email: email, createdAt: createdAt)
            completion(appUser)
        } else {
            print("User document does not exist")
            completion(nil)
        }
    }
}
