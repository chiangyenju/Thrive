import Foundation

struct BigFiveTest {
    static func loadQuestions() -> [Question] {
        return [
            Question(question: "I see myself as someone who is generally trusting."),
            Question(question: "I tend to be lazy."),
            Question(question: "I am relaxed and handle stress well."),
            Question(question: "I have a wide range of interests."),
            Question(question: "I am full of energy."),
        ].shuffled()
    }
}
