import Foundation

struct ChatMessage: Identifiable {
    let id: UUID
    let content: String
    let isFromUser: Bool
}
