import SwiftUI
import Firebase
import FirebaseStorage
import Combine

class UserProfileViewModel: ObservableObject {
    @Published var profileImage: Image? = Image(systemName: "person.crop.circle.fill")
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var createdAt: String = ""
    @Published var newUsername: String = ""
    @Published var showAlert = false
    @Published var alertMessage: String = ""
    @Published var imagePickerPresented = false
    @Published var selectedImage: UIImage?
    @Published var followersCount: Int = 0
    @Published var followingCount: Int = 0
    
    private var db = Firestore.firestore()
    
    func fetchUserProfile() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(uid).getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            if let document = document, document.exists {
                let data = document.data()
                let username = data?["username"] as? String ?? ""
                let profilePicURL = data?["profilePicURL"] as? String ?? ""
                let email = data?["email"] as? String ?? ""
                let createdAtTimestamp = data?["createdAt"] as? Timestamp
                let createdAt = createdAtTimestamp?.dateValue() ?? Date()
                let followersCount = data?["followersCount"] as? Int ?? 0
                let followingCount = data?["followingCount"] as? Int ?? 0
                self.username = username
                self.email = email
                self.createdAt = DateFormatter.localizedString(from: createdAt, dateStyle: .medium, timeStyle: .none)
                self.followersCount = followersCount
                self.followingCount = followingCount
                self.loadProfileImage(from: profilePicURL)
            } else {
                print("User document does not exist")
            }
        }
    }
    
    private func loadProfileImage(from url: String) {
        guard url.hasPrefix("https://") || url.hasPrefix("http://") else {
            print("Invalid URL scheme")
            return
        }
        
        let storageRef = Storage.storage().reference(forURL: url)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { [weak self] data, error in
            guard let self = self else { return }
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            if let data = data, let uiImage = UIImage(data: data) {
                self.profileImage = Image(uiImage: uiImage)
            }
        }
    }
    
    func uploadProfileImage(image: UIImage) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("profile_pictures/\(UUID().uuidString).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        storageRef.putData(imageData, metadata: nil) { [weak self] (metadata, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }
            storageRef.downloadURL { [weak self] (url, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    return
                }
                if let url = url {
                    let profilePicURL = url.absoluteString
                    self.db.collection("users").document(uid).updateData(["profilePicURL": profilePicURL]) { error in
                        if let error = error {
                            print("Error updating profile picture URL: \(error.localizedDescription)")
                            return
                        }
                        self.profileImage = Image(uiImage: image) // Update image preview
                    }
                }
            }
        }
    }
    
    func updateUsername() {
        guard !newUsername.isEmpty,
              newUsername.range(of: "^[A-Za-z].*$", options: .regularExpression) != nil else {
            alertMessage = "Username must start with an English character and cannot be empty."
            showAlert = true
            return
        }
        
        db.collection("users").whereField("username", isEqualTo: newUsername).getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error checking username uniqueness: \(error.localizedDescription)")
                self.alertMessage = "Error checking username uniqueness."
                self.showAlert = true
                return
            }
            
            if querySnapshot?.isEmpty == false {
                self.alertMessage = "Username is already taken."
                self.showAlert = true
                return
            }
            
            guard let uid = Auth.auth().currentUser?.uid else {
                self.alertMessage = "User not authenticated."
                self.showAlert = true
                return
            }
            
            self.db.collection("users").document(uid).updateData(["username": self.newUsername]) { error in
                if let error = error {
                    print("Error updating username: \(error.localizedDescription)")
                    self.alertMessage = "Error updating username."
                } else {
                    self.username = self.newUsername
                    self.alertMessage = "Username updated successfully!"
                }
                self.showAlert = true
            }
        }
    }
}
