import Firebase

func isValidUsername(_ username: String) -> Bool {
    // Check if the username starts with an English letter and is not empty
    let regex = "^[A-Za-z][A-Za-z0-9_]{3,15}$"
    let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
    return predicate.evaluate(with: username)
}

func updateUsername(uid: String, newUsername: String, completion: @escaping (Bool, String?) -> Void) {
    let db = Firestore.firestore()
    
    // Check if the username is valid
    guard isValidUsername(newUsername) else {
        completion(false, "Username must start with an English character and be between 4 to 16 characters long.")
        return
    }
    
    // Check if the username is unique
    db.collection("users").whereField("username", isEqualTo: newUsername).getDocuments { (querySnapshot, error) in
        if let error = error {
            print("Error checking username uniqueness: \(error.localizedDescription)")
            completion(false, "Error checking username uniqueness.")
            return
        }
        
        if querySnapshot?.isEmpty == false {
            completion(false, "Username is already taken.")
            return
        }
        
        // Update the username in Firestore
        db.collection("users").document(uid).updateData(["username": newUsername]) { error in
            if let error = error {
                print("Error updating username: \(error.localizedDescription)")
                completion(false, "Error updating username.")
                return
            }
            completion(true, nil)
        }
    }
}
