import SwiftUI
import FirebaseFirestoreSwift

struct Chat: Identifiable, Codable {
    @DocumentID var id: String?
    var participants: [String]
    var lastMessage: String
    var timestamp: Date
}

struct Message: Identifiable, Codable {
    @DocumentID var id: String?
    var chatID: String
    var senderID: String
    var content: String
    var timestamp: Date
}

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    let username: String
    let profilePicURL: String
}
