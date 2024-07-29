import Firebase
import SwiftUI
import FirebaseFirestoreSwift

struct AppUser: Identifiable, Codable {
    @DocumentID var id: String? // Firestore document ID
    let userID: String
    let username: String
    let profilePicURL: String
    let email: String
    let createdAt: Date
    var followersCount: Int
    var followingCount: Int
    var followers: [String]
    var following: [String]
}

