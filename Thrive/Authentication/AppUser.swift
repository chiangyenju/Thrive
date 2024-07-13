import Firebase

// Your User struct to hold custom user details
struct AppUser: Codable {
    let userID: String
    let username: String
    let profilePicURL: String
}

func fetchUserDetails(uid: String, completion: @escaping (AppUser?) -> Void) {
    let db = Firestore.firestore()
    db.collection("users").document(uid).getDocument { (document, error) in
        if let document = document, document.exists {
            let data = document.data()
            let username = data?["username"] as? String ?? "Anonymous"
            let profilePicURL = data?["profilePicURL"] as? String ?? ""
            let appUser = AppUser(userID: uid, username: username, profilePicURL: profilePicURL)
            completion(appUser)
        } else {
            print("User document does not exist")
            completion(nil)
        }
    }
}
