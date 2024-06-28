import SwiftUI
import Alamofire
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var currentMessage: String = ""

    init() {
        startConversation()
    }

    func startConversation() {
        let initialMessage = ChatMessage(id: UUID(), content: "Welcome! How can I assist you today?", isFromUser: false)
        messages.append(initialMessage)
    }

    func sendMessage() {
        let newMessage = ChatMessage(id: UUID(), content: currentMessage, isFromUser: true)
        messages.append(newMessage)
        saveMessage(newMessage)
        currentMessage = ""

        fetchResponse(for: newMessage.content)
    }

    func fetchResponse(for message: String) {
        let apiKey = Environment.getAPIKey() // Accessing Environment struct's static method
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo", // Updated model
            "messages": [
                ["role": "user", "content": message]
            ],
            "max_tokens": 100
        ]
        
        AF.request("https://api.openai.com/v1/chat/completions", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let json = data as? [String: Any] {
                        if let error = json["error"] as? [String: Any],
                           let errorCode = error["code"] as? String,
                           let errorMessage = error["message"] as? String {
                            print("Error code: \(errorCode)")
                            print("Error message: \(errorMessage)")
                            // Handle specific errors
                            if errorCode == "insufficient_quota" {
                                let botMessage = ChatMessage(id: UUID(), content: "You have exceeded your quota. Please check your OpenAI account.", isFromUser: false)
                                DispatchQueue.main.async {
                                    self.messages.append(botMessage)
                                }
                            }
                        } else if let choices = json["choices"] as? [[String: Any]],
                                  let message = choices.first?["message"] as? [String: Any],
                                  let text = message["content"] as? String {
                            let botMessage = ChatMessage(id: UUID(), content: text.trimmingCharacters(in: .whitespacesAndNewlines), isFromUser: false)
                            DispatchQueue.main.async {
                                self.messages.append(botMessage)
                                self.saveMessage(botMessage)
                            }
                        } else {
                            print("Unexpected JSON structure")
                        }
                    }
                case .failure(let error):
                    print("Error fetching response from OpenAI: \(error.localizedDescription)")
                }
            }
    }

    private func saveMessage(_ message: ChatMessage) {
        let db = Firestore.firestore()
        let messageData: [String: Any] = [
            "id": message.id.uuidString,
            "content": message.content,
            "isFromUser": message.isFromUser,
            "timestamp": Timestamp()
        ]
        
        db.collection("chats").addDocument(data: messageData) { error in
            if let error = error {
                print("Error saving message: \(error.localizedDescription)")
            }
        }
    }
}
