import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class ChatViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    @Published var searchResults: [AppUser] = []
    private var db = Firestore.firestore()
    private var authService = AuthService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Observe authentication changes and fetch chats
        authService.$user
            .compactMap { $0 }
            .sink { [weak self] user in
                self?.fetchChats(for: user.uid)
            }
            .store(in: &cancellables)
    }

    // Fetches the chats for the current user
    func fetchChats(for userId: String) {
        db.collection("chats")
            .whereField("participants", arrayContains: userId)
            .addSnapshotListener { [weak self] (snapshot, error) in
                if let error = error {
                    print("Error fetching chats: \(error.localizedDescription)")
                } else {
                    self?.chats = snapshot?.documents.compactMap { doc -> Chat? in
                        try? doc.data(as: Chat.self)
                    } ?? []
                }
            }
    }

    // Fetches users based on the search query
    func searchUsers(with query: String, completion: @escaping ([AppUser]) -> Void) {
        guard !query.isEmpty else {
            completion([])
            return
        }

        db.collection("users")
            .whereField("username", isGreaterThanOrEqualTo: query)
            .whereField("username", isLessThanOrEqualTo: query + "\u{f8ff}")
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error searching users: \(error.localizedDescription)")
                    completion([])
                } else {
                    let users = snapshot?.documents.compactMap { doc -> AppUser? in
                        try? doc.data(as: AppUser.self)
                    } ?? []
                    completion(users)
                }
            }
    }

    // Starts a chat with the selected user
    func startChat(with user: AppUser) {
        guard let currentUser = authService.user else {
            print("Current user not found")
            return
        }

        // Check if a chat already exists
        let existingChat = chats.first { chat in
            chat.participants.contains(user.userID)
        }
        
        if let chat = existingChat {
            // Navigate to existing chat
            print("Chat with \(user.username) already exists")
        } else {
            // Create a new chat
            let newChat = Chat(
                participants: [currentUser.uid, user.userID],
                lastMessage: "",
                timestamp: Date()
            )
            do {
                let _ = try db.collection("chats").addDocument(from: newChat)
                print("New chat started with \(user.username)")
            } catch {
                print("Error starting new chat: \(error.localizedDescription)")
            }
        }
    }

    // Fetch user details by their user ID
    func fetchUserDetails(uid: String, completion: @escaping (AppUser?) -> Void) {
        authService.fetchUserDetails(uid: uid, completion: completion)
    }
}
