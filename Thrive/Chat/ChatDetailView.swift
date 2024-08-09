import SwiftUI
import Firebase

struct ChatDetailView: View {
    var chat: Chat
    @State private var messageText: String = ""
    @State private var messages: [Message] = []
    private var db = Firestore.firestore()
    @State private var listener: ListenerRegistration?

    init(chat: Chat) {
        self.chat = chat
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(messages) { message in
                        Text(message.content)
                            .padding()
                            .background(message.senderID == Auth.auth().currentUser?.uid ? Color.blue : Color.gray)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: message.senderID == Auth.auth().currentUser?.uid ? .trailing : .leading)
                            .padding(.horizontal)
                    }
                }
            }
            
            HStack {
                TextField("Message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    sendMessage()
                }
            }
            .padding()
        }
        .navigationTitle("Chat")
        .onAppear(perform: fetchMessages)
        .onDisappear {
            listener?.remove()
        }
    }
    
    private func fetchMessages() {
        guard let chatID = chat.id else { return }
        
        listener = db.collection("messages")
            .whereField("chatID", isEqualTo: chatID)
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error.localizedDescription)")
                    return
                }
                
                messages = snapshot?.documents.compactMap { document -> Message? in
                    try? document.data(as: Message.self)
                } ?? []
            }
    }
    
    private func sendMessage() {
        guard let userID = Auth.auth().currentUser?.uid, !messageText.isEmpty else { return }
        
        let message = Message(chatID: chat.id ?? "", senderID: userID, content: messageText, timestamp: Date())
        
        do {
            try db.collection("messages").addDocument(from: message)
            messageText = ""
        } catch {
            print("Error sending message: \(error.localizedDescription)")
        }
    }
}

struct ChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChatDetailView(chat: Chat(id: "1", participants: ["user1", "user2"], lastMessage: "Hello", timestamp: Date()))
    }
}
