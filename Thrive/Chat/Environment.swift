import Foundation

struct Environment {
    static func getAPIKey() -> String {
        guard let filePath = Bundle.main.path(forResource: ".env", ofType: nil) else {
            fatalError("Couldn't find file '.env'. Make sure it's added to your main bundle.")
        }
        
        do {
            let contents = try String(contentsOfFile: filePath, encoding: .utf8)
            let lines = contents.split { $0.isNewline }
            for line in lines {
                let keyValuePair = line.split(separator: "=")
                if keyValuePair.count == 2 {
                    let key = keyValuePair[0].trimmingCharacters(in: .whitespacesAndNewlines)
                    let value = keyValuePair[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    if key == "OPENAI_API_KEY" {
                        return value
                    }
                }
            }
            fatalError("Couldn't find key 'OPENAI_API_KEY' in '.env'. Make sure it's correctly formatted.")
        } catch {
            fatalError("Couldn't read file '.env'. Error: \(error)")
        }
    }
}
