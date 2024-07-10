import SwiftUI

struct ChatDetailView: View {
    let messages: [ChatMessage]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(messages) { message in
                    HStack {
                        if message.isFromUser {
                            Spacer()
                            Text(message.content)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        } else {
                            Text(message.content)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            Spacer()
                        }
                    }
                }
            }
            .padding()
        }
        .navigationBarTitle("Chat Detail", displayMode: .inline)
        .onAppear {
            print("Messages count: \(messages.count)")
        }
    }
}

struct ChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChatDetailView(messages: [
            ChatMessage(id: UUID(), content: "Hello, how can I help you?", isFromUser: false, timestamp: Date()),
            ChatMessage(id: UUID(), content: "I need assistance with my test.", isFromUser: true, timestamp: Date())
        ])
    }
}
