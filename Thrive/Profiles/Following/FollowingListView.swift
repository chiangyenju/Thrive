import SwiftUI

struct FollowingListView: View {
    @StateObject private var viewModel = FollowingListViewModel()

    var body: some View {
        VStack {
            TextField("Search by username", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if !viewModel.searchText.isEmpty {
                List(viewModel.filteredUsers) { user in
                    HStack {
                        if let url = URL(string: user.profilePicURL) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } placeholder: {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }

                        VStack(alignment: .leading) {
                            Text(user.username)
                                .font(.headline)
                        }

                        Spacer()

                        Button(action: {
                            viewModel.toggleFollow(user: user)
                        }) {
                            Text(user.followers.contains(viewModel.currentUserID ?? "") ? "Unfollow" : "Follow")
                                .foregroundColor(.white)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .background(user.followers.contains(viewModel.currentUserID ?? "") ? Color.red : Color.blue)
                                .cornerRadius(5)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .frame(maxHeight: 200) // Limit the dropdown height
            }

            List(viewModel.followingUsers) { user in
                HStack {
                    if let url = URL(string: user.profilePicURL) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        } placeholder: {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }

                    VStack(alignment: .leading) {
                        Text(user.username)
                            .font(.headline)
                    }

                    Spacer()

                    Button(action: {
                        viewModel.toggleFollow(user: user)
                    }) {
                        Text(user.followers.contains(viewModel.currentUserID ?? "") ? "Unfollow" : "Follow")
                            .foregroundColor(.white)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(user.followers.contains(viewModel.currentUserID ?? "") ? Color.red : Color.blue)
                            .cornerRadius(5)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Following")
        .onAppear {
            viewModel.fetchFollowingUsers()
        }
    }
}
