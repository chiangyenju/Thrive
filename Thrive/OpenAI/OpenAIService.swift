import Foundation
import Alamofire

class OpenAIService {
    private let apiKey = Environment.getAPIKey() // Adjust as per your setup
    
    func fetchResponse(for message: String, completion: @escaping (Result<String, Error>) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": message]
            ],
            "max_tokens": 100
        ]
        
        AF.request("https://api.openai.com/v1/chat/completions", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let json = data as? [String: Any],
                       let choices = json["choices"] as? [[String: Any]],
                       let message = choices.first?["message"] as? [String: Any],
                       let text = message["content"] as? String {
                        completion(.success(text))
                    } else {
                        completion(.failure(NSError(domain: "OpenAIService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Unexpected JSON structure"])))
                    }
                case .failure(let error):
                    if response.response?.statusCode == 429 {
                        completion(.failure(NSError(domain: "OpenAIService", code: 429, userInfo: [NSLocalizedDescriptionKey: "Rate limit exceeded. Please try again later."])))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }
}
