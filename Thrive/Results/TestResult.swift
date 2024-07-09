import Foundation
import FirebaseFirestoreSwift

struct TestResult: Identifiable, Codable {
    @DocumentID var id: String?
    let testName: String
    let userName: String
    let date: Date
    let mainTestResult: String
    let iconName: String
}

extension TestResult {
    static let exampleTestResults: [TestResult] = [
        TestResult(id: UUID().uuidString, testName: "16 Personality", userName: "John Doe", date: Date(), mainTestResult: "INTJ", iconName: "16personality_sq"),
        // Add more example test results as needed
    ]
}
