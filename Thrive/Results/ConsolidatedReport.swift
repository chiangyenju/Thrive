import Foundation
import FirebaseFirestoreSwift

struct ConsolidatedReport: Identifiable, Codable {
    @DocumentID var id: String?
    var reportID: String
    var date: Date
    var content: String
    var messages: [TakeTestMessage]
}
