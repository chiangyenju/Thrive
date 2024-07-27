import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

class AuthService: ObservableObject {
    @Published var user: FirebaseAuth.User?

    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    private var db = Firestore.firestore()

    init() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.user = user
            if let user = user {
                self?.ensureUserDocumentExists(user: user)
            }
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(error)
                return
            }
            guard let user = result?.user else {
                completion(NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "User creation failed"]))
                return
            }
            self?.user = user
            self?.ensureUserDocumentExists(user: user)
            completion(nil)
        }
    }

    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(error)
                return
            }
            guard let user = result?.user else {
                completion(NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "User login failed"]))
                return
            }
            self?.user = user
            self?.ensureUserDocumentExists(user: user)
            completion(nil)
        }
    }

    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            self.user = nil
            completion(nil)
        } catch {
            completion(error)
        }
    }

    private func ensureUserDocumentExists(user: FirebaseAuth.User) {
        let userRef = db.collection("users").document(user.uid)
        userRef.getDocument { [weak self] document, error in
            if let error = error {
                print("Error checking user document: \(error.localizedDescription)")
                return
            }
            if let document = document, document.exists {
                self?.updateUserDocumentIfNeeded(document: document)
            } else {
                self?.createUserDocument(user: user)
            }
        }
    }

    private func createUserDocument(user: FirebaseAuth.User) {
        let newUser = [
            "userID": user.uid,
            "username": user.email?.components(separatedBy: "@").first ?? "Anonymous",
            "profilePicURL": "",
            "email": user.email ?? "",
            "createdAt": Timestamp(date: Date()),
            "followersCount": 0,
            "followingCount": 0,
            "followers": [],
            "following": []
        ] as [String : Any]
        
        db.collection("users").document(user.uid).setData(newUser) { error in
            if let error = error {
                print("Error creating user document: \(error.localizedDescription)")
            }
        }
    }

    private func updateUserDocumentIfNeeded(document: DocumentSnapshot) {
        var updates = [String: Any]()
        let data = document.data() ?? [:]

        if data["userID"] == nil {
            updates["userID"] = document.documentID
        }
        if data["username"] == nil {
            updates["username"] = document.documentID.components(separatedBy: "@").first ?? "Anonymous"
        }
        if data["profilePicURL"] == nil {
            updates["profilePicURL"] = ""
        }
        if data["email"] == nil {
            updates["email"] = user?.email ?? ""
        }
        if data["createdAt"] == nil {
            updates["createdAt"] = Timestamp(date: Date())
        }
        if data["followersCount"] == nil {
            updates["followersCount"] = 0
        }
        if data["followingCount"] == nil {
            updates["followingCount"] = 0
        }
        if data["followers"] == nil {
            updates["followers"] = []
        }
        if data["following"] == nil {
            updates["following"] = []
        }

        if !updates.isEmpty {
            db.collection("users").document(document.documentID).updateData(updates) { error in
                if let error = error {
                    print("Error updating user document: \(error.localizedDescription)")
                }
            }
        }
    }

    func followUser(currentUserID: String, targetUserID: String, completion: @escaping (Error?) -> Void) {
        let currentUserRef = db.collection("users").document(currentUserID)
        let targetUserRef = db.collection("users").document(targetUserID)

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let currentUserDoc: DocumentSnapshot
            let targetUserDoc: DocumentSnapshot
            do {
                try currentUserDoc = transaction.getDocument(currentUserRef)
                try targetUserDoc = transaction.getDocument(targetUserRef)
            } catch let error as NSError {
                errorPointer?.pointee = error
                return nil
            }

            guard var currentUserFollowing = currentUserDoc.data()?["following"] as? [String],
                  var targetUserFollowers = targetUserDoc.data()?["followers"] as? [String] else {
                return nil
            }

            if !currentUserFollowing.contains(targetUserID) {
                currentUserFollowing.append(targetUserID)
                transaction.updateData(["following": currentUserFollowing, "followingCount": currentUserFollowing.count], forDocument: currentUserRef)
            }

            if !targetUserFollowers.contains(currentUserID) {
                targetUserFollowers.append(currentUserID)
                transaction.updateData(["followers": targetUserFollowers, "followersCount": targetUserFollowers.count], forDocument: targetUserRef)
            }

            return nil
        }) { (object, error) in
            completion(error)
        }
    }

    func unfollowUser(currentUserID: String, targetUserID: String, completion: @escaping (Error?) -> Void) {
        let currentUserRef = db.collection("users").document(currentUserID)
        let targetUserRef = db.collection("users").document(targetUserID)

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let currentUserDoc: DocumentSnapshot
            let targetUserDoc: DocumentSnapshot
            do {
                try currentUserDoc = transaction.getDocument(currentUserRef)
                try targetUserDoc = transaction.getDocument(targetUserRef)
            } catch let error as NSError {
                errorPointer?.pointee = error
                return nil
            }

            guard var currentUserFollowing = currentUserDoc.data()?["following"] as? [String],
                  var targetUserFollowers = targetUserDoc.data()?["followers"] as? [String] else {
                return nil
            }

            if let index = currentUserFollowing.firstIndex(of: targetUserID) {
                currentUserFollowing.remove(at: index)
                transaction.updateData(["following": currentUserFollowing, "followingCount": currentUserFollowing.count], forDocument: currentUserRef)
            }

            if let index = targetUserFollowers.firstIndex(of: currentUserID) {
                targetUserFollowers.remove(at: index)
                transaction.updateData(["followers": targetUserFollowers, "followersCount": targetUserFollowers.count], forDocument: targetUserRef)
            }

            return nil
        }) { (object, error) in
            completion(error)
        }
    }
}
