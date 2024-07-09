import Foundation

struct SixteenPersonalityTest {
    static func loadQuestions() -> [Question] {
        return [
            Question(question: "I am energized by social interactions."),
            Question(question: "I enjoy spending time alone."),
            Question(question: "I follow a consistent routine."),
            Question(question: "I am curious about many things."),
            Question(question: "I prefer to improvise rather than plan."),
        ].shuffled()
    }
}



