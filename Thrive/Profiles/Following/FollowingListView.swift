import SwiftUI

struct FollowingListView: View {
    @StateObject private var viewModel = FollowingListViewModel()
    
    var body: some View {
        VStack {
            TextField("Search by username", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
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
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Following")
    }
}
