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
    
    private var questionIndex = 0
    private var feedbackResponses: [String] = []
    private var db = Firestore.firestore()
    
    func startTest(_ testName: String) {
        switch testName {
        case "16 Personality":
            currentTest = Test(name: testName, questions: SixteenPersonalityTest.loadQuestions())
        case "Big Five":
            currentTest = Test(name: testName, questions: BigFiveTest.loadQuestions())
        default:
            return
        }
        let greeting = "Welcome to Thrive! Please answer these questions for your \(testName)."
        messages.append(ChatMessage(id: UUID(), content: greeting, isFromUser: false))
        sendNextQuestion()
    }

    func sendNextQuestion() {
        guard let test = currentTest else { return }
        if questionIndex < test.questions.count {
            let question = test.questions[questionIndex]
            messages.append(ChatMessage(id: UUID(), content: question.question, isFromUser: false))
        } else {
            analyzeResponses()
        }
    }

    func sendMessage() {
        guard let currentTest = currentTest else { return }
        guard questionIndex < currentTest.questions.count else {
            print("No more questions to answer.")
            return
        }
        
        let question = currentTest.questions[questionIndex].question
        let response = currentMessage
        
        // Append user's message to messages array
        messages.append(ChatMessage(id: UUID(), content: response, isFromUser: true))
        
        let prompt = """
        You are conducting a test named \(currentTest.name). The question is: "\(question)". The user's response is "\(response)". Provide feedback based on this response. Exclude texts where you repeat the question and response. Just simply start providing feedback.
        """
        
        fetchResponse(for: prompt) { response in
            // Process OpenAI response to ensure it provides appropriate feedback
            let formattedResponse = self.formatResponse(response)
            self.messages.append(ChatMessage(id: UUID(), content: formattedResponse, isFromUser: false))
            self.feedbackResponses.append(formattedResponse)

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
        End the analysis with "Your result is: <Type>" Replace <Type> with the specific type.
        """
        
        fetchResponse(for: analysisPrompt) { response in
            // Process OpenAI response for analysis
            let formattedResponse = self.formatResponse(response)
            self.messages.append(ChatMessage(id: UUID(), content: formattedResponse, isFromUser: false))
            
            if let result = self.extractResult(from: formattedResponse) {
                self.saveTestResult(mainTestResult: result)
            }

            self.currentTest = nil
            self.questionIndex = 0
            self.feedbackResponses.removeAll() // Clear feedback responses for next test
        }
    }

    private func saveTestResult(mainTestResult: String) {
        guard let user = Auth.auth().currentUser, let test = currentTest else { return }

        let testResult = TestResult(
            id: UUID().uuidString,
            testName: test.name,
            userName: user.displayName ?? "Anonymous",
            date: Date(),
            mainTestResult: mainTestResult,
            iconName: getIconName(for: test.name)
        )

        do {
            try db.collection("testResults").document(user.uid).collection("results").document(testResult.id!).setData(from: testResult)

            for message in messages {
                do {
                    try db.collection("testResults").document(user.uid).collection("results").document(testResult.id!).collection("messages").addDocument(from: message)
                } catch {
                    print("Error saving message: \(error.localizedDescription)")
                }
            }
            
            print("Test result saved successfully.")
        } catch {
            print("Error saving test result: \(error.localizedDescription)")
        }
    }

    
    private func getIconName(for testName: String) -> String {
        switch testName {
        case "16 Personality":
            return "16personality_sq"
        case "Big Five":
            return "bigfive_sq"
        default:
            return "default_icon"
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
                        print("Unexpected JSON structure")
                        completion("Sorry, I couldn't process that.")
                    }
                case .failure(let error):
                    print("Error fetching response from OpenAI: \(error.localizedDescription)")
                    completion("Sorry, there was an error fetching the response.")
                }
            }
    }
    
    private func formatResponse(_ response: String) -> String {
        // Customize response formatting as needed
        // Example: Add contextual understanding or specific responses
        return response // Adjust as per your specific requirements
    }

    private func extractResult(from response: String) -> String? {
        // Extract the specific type or result from the response
        let pattern = "Your result is: (\\w+)"
        if let match = response.range(of: pattern, options: .regularExpression) {
            let result = response[match].replacingOccurrences(of: "Your result is: ", with: "")
            return result
        }
        return nil
    }

}
