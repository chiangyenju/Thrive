import Foundation
import FirebaseFirestoreSwift

struct TestResult: Identifiable, Codable {
    let id: String
    let testName: String
    let iconName: String
    let date: Date
    let userName: String
    let mainTestResult: String

    // Sample data for previews
    static let exampleTestResults: [TestResult] = [
        TestResult(id: "1", testName: "MBTI", iconName: "icon1", date: Date(), userName: "User1", mainTestResult: "ENTJ"),
        // Add more examples as needed
    ]
}

