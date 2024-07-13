import SwiftUI
import Combine
import Alamofire
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var currentMessage: String = ""
    @Published var currentTest: Test?
    @Published var selectedMessages: [ChatMessage] = []
    @Published var showChatDetail = false
    @Published var testResults: [TestResult] = []

    private var questionIndex = 0
    private var feedbackResponses: [String] = []
    private var db = Firestore.firestore()

    func startTest(_ testName: String) {
        switch testName {
        case "16 Personality":
            currentTest = Test(name: testName, squareImageName: "16personality_sq", questions: SixteenPersonalityTest.loadQuestions())
        case "Big Five":
            currentTest = Test(name: testName, squareImageName: "bigfive_sq", questions: BigFiveTest.loadQuestions())
        default:
            return
        }
        let greeting = "Welcome to Thrive! Please answer these questions for your \(testName)."
        let timestamp = Date()
        messages.append(ChatMessage(id: UUID(), content: greeting, isFromUser: false, timestamp: timestamp))
        sendNextQuestion()
    }

    func sendNextQuestion() {
        guard let test = currentTest else { return }
        if questionIndex < test.questions.count {
            let question = test.questions[questionIndex]
            let timestamp = Date()
            messages.append(ChatMessage(id: UUID(), content: question.question, isFromUser: false, timestamp: timestamp))
        } else {
            analyzeResponses()
        }
    }

    func sendMessage() {
        guard let currentTest = currentTest else { return }
        guard questionIndex < currentTest.questions.count else {
            return
        }

        let question = currentTest.questions[questionIndex].question
        let response = currentMessage

        let timestamp = Date()
        messages.append(ChatMessage(id: UUID(), content: response, isFromUser: true, timestamp: timestamp))

        let prompt = """
        You are conducting a test named \(currentTest.name). The question is: "\(question)". The user's response is "\(response)". Provide feedback based on this response. Exclude texts where you repeat the question and response. Just simply start providing feedback.
        """

        fetchResponse(for: prompt) { response in
            let formattedResponse = self.formatResponse(response)
            let timestamp = Date()
            self.messages.append(ChatMessage(id: UUID(), content: formattedResponse, isFromUser: false, timestamp: timestamp))
            self.feedbackResponses.append(formattedResponse)

            if let result = self.extractResult(from: formattedResponse) {
                self.saveTestResult(mainTestResult: result)
            }

            self.currentTest?.questions[self.questionIndex].response = self.currentMessage
            self.questionIndex += 1
            self.sendNextQuestion()
        }

        currentMessage = ""
    }

    private func analyzeResponses() {
        guard let test = currentTest else { return }

        let feedbackText = feedbackResponses.joined(separator: "\n")

        let analysisPrompt = """
        You are an expert counselor. Analyze the following responses to the \(test.name) test and provide a comprehensive result:
        \(feedbackText). Based on this analysis, what is the specific type or result for the person in \(test.name)?
        End the analysis in a new line and "Your result is: <Type>" Replace <Type> with the specific type.
        """

        fetchResponse(for: analysisPrompt) { response in
            let formattedResponse = self.formatResponse(response)
            let timestamp = Date()
            self.messages.append(ChatMessage(id: UUID(), content: formattedResponse, isFromUser: false, timestamp: timestamp))

            if let result = self.extractResult(from: formattedResponse) {
                self.saveTestResult(mainTestResult: result)
            }

            self.currentTest = nil
            self.questionIndex = 0
            self.feedbackResponses.removeAll()
        }
    }

    func saveTestResult(mainTestResult: String) {
        guard let user = Auth.auth().currentUser else { return }
        guard let currentTest = self.currentTest else { return }

        let testName = currentTest.name
        let testIconPic = currentTest.squareImageName

        fetchUserDetails(uid: user.uid) { appUser in
            guard let appUser = appUser else { return }

            let db = Firestore.firestore()
            let testResult = TestResult(
                userID: appUser.userID,
                username: appUser.username,
                userProfilePicURL: appUser.profilePicURL,
                testID: UUID().uuidString,
                testName: testName,
                testIconPic: testIconPic,
                date: Date(),
                conductedByID: appUser.userID,
                conductedByUsername: appUser.username,
                conductedByProfilePicURL: appUser.profilePicURL,
                mainTestResult: mainTestResult
            )

            do {
                let userTestResultsRef = db.collection("testResults").document(appUser.userID).collection("results")
                let testResultRef = userTestResultsRef.document(testResult.testID)
                try testResultRef.setData(from: testResult)

                for message in self.messages {
                    var messageWithTimestamp = message
                    messageWithTimestamp.timestamp = Date()
                    let messageRef = testResultRef.collection("messages").document()
                    try messageRef.setData(from: messageWithTimestamp)
                }
            } catch {
                print("Error saving test result: \(error.localizedDescription)")
            }
        }
    }

    private func fetchResponse(for message: String, completion: @escaping (String) -> Void) {
        let apiKey = Environment.getAPIKey()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]

        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": message]
            ],
            "max_tokens": 150
        ]

        AF.request("https://api.openai.com/v1/chat/completions", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let json = data as? [String: Any],
                       let choices = json["choices"] as? [[String: Any]],
                       let message = choices.first?["message"] as? [String: Any],
                       let text = message["content"] as? String {
                        completion(text.trimmingCharacters(in: .whitespacesAndNewlines))
                    } else {
                        completion("Sorry, I couldn't process that.")
                    }
                case .failure:
                    completion("Sorry, there was an error fetching the response.")
                }
            }
    }

    private func formatResponse(_ response: String) -> String {
        return response
    }

    private func extractResult(from response: String) -> String? {
        let pattern = "Your result is: (\\w+)"
        if let match = response.range(of: pattern, options: .regularExpression) {
            let result = response[match].replacingOccurrences(of: "Your result is: ", with: "")
            return result
        }
        return nil
    }
}
