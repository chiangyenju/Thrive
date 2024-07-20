import Foundation
import FirebaseFirestoreSwift

struct TestResult: Identifiable, Codable, Hashable {
    var id: String { testID }
    let userID: String
    let username: String
    let userProfilePicURL: String
    let testID: String
    let testName: String
    let testIconPic: String
    let date: Date
    let conductedByID: String
    let conductedByUsername: String
    let conductedByProfilePicURL: String
    let mainTestResult: String
}


