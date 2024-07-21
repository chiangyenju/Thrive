import SwiftUI
import Firebase
import FirebaseStorage
import UIKit

struct ProfilePageView: View {
    @State private var profileImage: Image? = Image(systemName: "person.crop.circle.fill")
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var createdAt: String = ""
    @State private var imagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var newUsername: String = ""
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    @StateObject private var userViewModel = UserViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                profileImage?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                    .padding()
                    .frame(width: 150, height: 150) // Enlarged placeholder
                    .onTapGesture {
                        imagePickerPresented = true
                    }
                
                Text(username)
                    .font(.title)
                    .bold()
                    .padding(.bottom, 10)
                
                Text(email)
                    .font(.subheadline)
                    .padding(.bottom, 10)
                
                Text("Joined on \(createdAt)")
                    .font(.subheadline)
                    .padding(.bottom, 10)
                
                TextField("Enter new username", text: $newUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    updateUsername()
                }) {
                    Text("Update Username")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Update Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                Spacer()
            }
            .navigationTitle("Profile")
            .onAppear {
                userViewModel.fetchUserProfile { appUser in
                    if let appUser = appUser {
                        self.username = appUser.username
                        self.email = appUser.email
                        self.createdAt = DateFormatter.localizedString(from: appUser.createdAt, dateStyle: .medium, timeStyle: .none)
                        self.loadProfileImage(from: appUser.profilePicURL)
                    }
                }
            }
            .sheet(isPresented: $imagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage, onImageSelected: uploadProfileImage)
            }
        }
    }
    
    private func loadProfileImage(from url: String) {
        guard url.hasPrefix("https://") || url.hasPrefix("http://") else {
            print("Invalid URL scheme")
            return
        }
        
        let storageRef = Storage.storage().reference(forURL: url)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            if let data = data, let uiImage = UIImage(data: data) {
                self.profileImage = Image(uiImage: uiImage)
            }
        }
    }
    
    private func uploadProfileImage(image: UIImage) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("profile_pictures/\(UUID().uuidString).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    return
                }
                if let url = url {
                    let profilePicURL = url.absoluteString
                    let db = Firestore.firestore()
                    db.collection("users").document(uid).updateData(["profilePicURL": profilePicURL]) { error in
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
    
    private func updateUsername() {
        // Validate new username
        guard !newUsername.isEmpty,
              newUsername.range(of: "^[A-Za-z].*$", options: .regularExpression) != nil else {
            alertMessage = "Username must start with an English character and cannot be empty."
            showAlert = true
            return
        }
        
        userViewModel.updateUsername(newUsername: newUsername) { success, message in
            if success {
                username = newUsername
                alertMessage = "Username updated successfully!"
            } else {
                alertMessage = message ?? "Failed to update username."
            }
            showAlert = true
        }
    }
}
