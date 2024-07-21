import Firebase

// Your User struct to hold custom user details
struct AppUser: Codable {
    let userID: String
    let username: String
    let profilePicURL: String
    let email: String
    let createdAt: Date
}
