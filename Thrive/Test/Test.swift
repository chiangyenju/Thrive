import Foundation

struct Test: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let bannerImageName: String
    let squareImageName: String
    let author: String
    
    static let example = Test(name: "16 Personality", bannerImageName: "16personality_ft", squareImageName: "16personality_sq", author: "Author Name")
    static let exampleTests: [Test] = [
        Test(name: "16 Personality", bannerImageName: "16personality_ft", squareImageName: "16personality_sq", author: "Author Name"),
        Test(name: "Big Five", bannerImageName: "bigfive_ft", squareImageName: "bigfive_sq", author: "Author Name"),
        Test(name: "Enneagram", bannerImageName: "enneagram_ft", squareImageName: "enneagram_sq", author: "Author Name"),
        Test(name: "Career Leaders", bannerImageName: "careerleaders_ft", squareImageName: "careerleaders_sq", author: "Author Name")
    ]
}
