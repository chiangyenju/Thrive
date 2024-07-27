import SwiftUI
import Firebase

struct UserProfileView: View {
    @StateObject private var viewModel = UserProfileViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ProfileImageView(image: $viewModel.profileImage, imagePickerPresented: $viewModel.imagePickerPresented, onImageSelected: viewModel.uploadProfileImage)
                    .padding(.top, 20)
                
                Text(viewModel.username)
                    .font(.title)
                    .bold()
                    .padding(.top, 10)
                
                Text(viewModel.email)
                    .font(.subheadline)
                    .padding(.top, 5)
                
                Text("Joined on \(viewModel.createdAt)")
                    .font(.subheadline)
                    .padding(.top, 5)
                
                TextField("Enter new username", text: $viewModel.newUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                Button(action: {
                    viewModel.updateUsername()
                }) {
                    Text("Update Username")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Update Status"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                }
                
                HStack {
                    NavigationLink(destination: FollowersListView()) {
                        VStack {
                            Text("Followers")
                            Text("\(viewModel.followersCount)")
                                .font(.title2)
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: FollowingListView()) {
                        VStack {
                            Text("Following")
                            Text("\(viewModel.followingCount)")
                                .font(.title2)
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                    }
                }
                .padding(.top, 20)
                
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
// Placeholder views for followers and following lists
struct FollowingListView: View {
    var body: some View {
        Text("Followers List")
            .navigationTitle("Followers")
    }
}

// Placeholder views for followers and following lists
struct FollowersListView: View {
    var body: some View {
        Text("Followers List")
            .navigationTitle("Followers")
    }
}


