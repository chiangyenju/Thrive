import SwiftUI

import DotEnv

// Load the environment variables from .env file
let env = DotEnv()

// Access the API key
let apiKey = env.get("API_KEY")


struct ChatbotView: View {
    @State private var messages: [Message] = [] // Store chat messages here
    @State private var newMessage = ""

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages, id: \.id) { message in
                        MessageView(message: message)
                    }
                }
                .padding()
            }

            Divider()

            HStack {
                TextField("Type a message...", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: sendMessage) {
                    Text("Send")
                }
                .padding(.trailing)
            }
            .padding()
        }
        .navigationTitle("Chatbot")
        .onAppear(perform: {
            // Load initial messages if any
            // Example: messages = loadMessagesFromFirestore()
        })
    }

    private func sendMessage() {
        // Create a new message and add to messages array
        let message = Message(text: newMessage, isUser: true)
        messages.append(message)

        // Send message to OpenAI or Firebase Firestore (implement later)
        // Example: sendMessageToOpenAI(message.text)

        // Clear the input field
        newMessage = ""
    }
}

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool // Whether the message is from the user or bot
}

struct MessageView: View {
    let message: Message

    var body: some View {
        Group {
            if message.isUser {
                HStack {
                    Spacer()
                    Text(message.text)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            } else {
                HStack {
                    Text(message.text)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    Spacer()
                }
            }
        }
    }
}


struct ChatbotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatbotView()
    }
}
