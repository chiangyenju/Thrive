import Firebase

struct AppUser: Identifiable, Codable {
    var id: String? // Firestore document ID
    let userID: String
    let username: String
    let profilePicURL: String
    let email: String
    let createdAt: Date
    let followersCount: Int
    let followingCount: Int
}
