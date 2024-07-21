import Firebase
import FirebaseFirestore

class UserViewModel: ObservableObject {
    private var db = Firestore.firestore()
    
    func fetchUserProfile(completion: @escaping (AppUser?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        db.collection("users").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let username = data?["username"] as? String ?? ""
                let profilePicURL = data?["profilePicURL"] as? String ?? ""
                let email = data?["email"] as? String ?? ""
                let createdAtTimestamp = data?["createdAt"] as? Timestamp
                let createdAt = createdAtTimestamp?.dateValue() ?? Date()
                let appUser = AppUser(userID: uid, username: username, profilePicURL: profilePicURL, email: email, createdAt: createdAt)
                completion(appUser)
            } else {
                print("User document does not exist")
                completion(nil)
            }
        }
    }
    
    func updateUsername(newUsername: String, completion: @escaping (Bool, String?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(false, "User not authenticated")
            return
        }
        db.collection("users").document(uid).updateData(["username": newUsername]) { error in
            if let error = error {
                print("Error updating username: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
}
