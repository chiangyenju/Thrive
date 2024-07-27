import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirestoreService {
    func saveMessage(testId: String, message: TakeTestMessage, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let messageData: [String: Any] = [
            "id": message.id.uuidString,
            "content": message.content,
            "isFromUser": message.isFromUser,
            "timestamp": Timestamp()
        ]
        
        Firestore.firestore().collection("users").document(userId).collection("tests").document(testId).collection("messages").addDocument(data: messageData) { error in
            completion(error)
        }
    }
}
