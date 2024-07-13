import Foundation

struct SixteenPersonalityTest {
    static func loadQuestions() -> [Question] {
        return [
            Question(question: "I am energized by social interactions."),
            Question(question: "I enjoy spending time alone."),
            Question(question: "I follow a consistent routine and prefer planning ahead."),
            Question(question: "I follow my intuition instead of sensing."),
            Question(question: "I follow my logical head rather than my feelings."),
        ].shuffled()
    }
}



