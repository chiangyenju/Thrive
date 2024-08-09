import SwiftUI

struct ChatListView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    @State private var searchText: String = ""
    @State private var matchingUsers: [AppUser] = []

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search for users...", text: $searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: searchText) { newValue in
                        searchUsers()
                    }

                // Display matching users
                List(matchingUsers) { user in
                    HStack {
                        Text(user.username)
                        Spacer()
                        Button(action: {
                            chatViewModel.startChat(with: user)
                        }) {
                            Text("Start Chat")
                                .padding(8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                    }
                }
                
                // Existing chat list
                List(chatViewModel.chats) { chat in
                    NavigationLink(destination: ChatDetailView(chat: chat)) {
                        HStack {
                            Text(chat.lastMessage)
                            Spacer()
                            Text(chat.timestamp, style: .time)
                        }
                    }
                }
            }
            .navigationTitle("Chats")
        }
    }

    // Function to search users
    private func searchUsers() {
        chatViewModel.searchUsers(with: searchText) { users in
            self.matchingUsers = users
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView().environmentObject(ChatViewModel())
    }
}
