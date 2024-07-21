import SwiftUI
import Firebase

struct ProfilePageView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ProfileImageView(image: $viewModel.profileImage, imagePickerPresented: $viewModel.imagePickerPresented, onImageSelected: viewModel.uploadProfileImage)
                
                Text(viewModel.username)
                    .font(.title)
                    .bold()
                    .padding(.bottom, 10)
                
                Text(viewModel.email)
                    .font(.subheadline)
                    .padding(.bottom, 10)
                
                Text("Joined on \(viewModel.createdAt)")
                    .font(.subheadline)
                    .padding(.bottom, 10)
                
                TextField("Enter new username", text: $viewModel.newUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    viewModel.updateUsername()
                }) {
                    Text("Update Username")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Update Status"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                }
                
                HStack {
                    VStack {
                        Text("Followers")
                        Text("\(viewModel.followersCount)")
                            .font(.title2)
                            .onTapGesture {
                                // Navigate to Followers list
                            }
                    }
                    .padding()
                    
                    VStack {
                        Text("Following")
                        Text("\(viewModel.followingCount)")
                            .font(.title2)
                            .onTapGesture {
                                // Navigate to Following list
                            }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Profile")
            .onAppear {
                viewModel.fetchUserProfile()
            }
            .sheet(isPresented: $viewModel.imagePickerPresented) {
                ImagePicker(selectedImage: $viewModel.selectedImage, onImageSelected: viewModel.uploadProfileImage)
            }
        }
    }
}
