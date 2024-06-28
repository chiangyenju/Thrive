import Foundation

struct Result: Identifiable {
    let id: String
    let testName: String
    let userName: String
    let date: Date
    let mainResult: String
    let iconName: String
}



extension Result {
    static let exampleResults: [Result] = [
        Result(id: UUID().uuidString, testName: "16 Personality", userName: "John Doe", date: Date(), mainResult: "INTJ", iconName: "16personality_sq"),
        Result(id: UUID().uuidString, testName: "Big Five", userName: "Jane Smith", date: Date(), mainResult: "Open", iconName: "bigfive_sq"),
        Result(id: UUID().uuidString, testName: "Enneagram", userName: "Alice Johnson", date: Date(), mainResult: "Type 3", iconName: "enneagram_sq"),
        Result(id: UUID().uuidString, testName: "Career Leaders", userName: "Bob Brown", date: Date(), mainResult: "Leader", iconName: "careerleaders_sq"),
        Result(id: UUID().uuidString, testName: "16 Personality", userName: "Charlie Davis", date: Date(), mainResult: "ENTP", iconName: "16personality_sq"),
        Result(id: UUID().uuidString, testName: "Big Five", userName: "Eve Martin", date: Date(), mainResult: "Conscientious", iconName: "bigfive_sq"),
        Result(id: UUID().uuidString, testName: "Enneagram", userName: "Frank Wilson", date: Date(), mainResult: "Type 7", iconName: "enneagram_sq"),
        Result(id: UUID().uuidString, testName: "Career Leaders", userName: "Grace Lee", date: Date(), mainResult: "Innovator", iconName: "careerleaders_sq"),
        Result(id: UUID().uuidString, testName: "16 Personality", userName: "Hank Kim", date: Date(), mainResult: "ISFJ", iconName: "16personality_sq"),
        Result(id: UUID().uuidString, testName: "Big Five", userName: "Ivy Chen", date: Date(), mainResult: "Agreeable", iconName: "bigfive_sq"),
        Result(id: UUID().uuidString, testName: "Enneagram", userName: "Jackie Turner", date: Date(), mainResult: "Type 2", iconName: "enneagram_sq"),
        Result(id: UUID().uuidString, testName: "Career Leaders", userName: "Ken Parker", date: Date(), mainResult: "Strategist", iconName: "careerleaders_sq"),
        Result(id: UUID().uuidString, testName: "16 Personality", userName: "Laura Baker", date: Date(), mainResult: "INFP", iconName: "16personality_sq"),
        Result(id: UUID().uuidString, testName: "Big Five", userName: "Michael Rodriguez", date: Date(), mainResult: "Neurotic", iconName: "bigfive_sq")
    ]
}
