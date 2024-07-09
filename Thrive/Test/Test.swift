import Foundation

struct Test: Identifiable, Hashable, Codable {
    let id: UUID
    let name: String
    let bannerImageName: String?
    let squareImageName: String?
    let author: String?
    var questions: [Question]

    init(id: UUID = UUID(), name: String, bannerImageName: String? = nil, squareImageName: String? = nil, author: String? = nil, questions: [Question] = []) {
        self.id = id
        self.name = name
        self.bannerImageName = bannerImageName
        self.squareImageName = squareImageName
        self.author = author
        self.questions = questions
    }

    static let example = Test(name: "16 Personality")
    static let exampleTests: [Test] = [
        Test(name: "16 Personality", bannerImageName: "16personality_ft", squareImageName: "16personality_sq", author: "Author Name"),
        Test(name: "Big Five", bannerImageName: "bigfive_ft", squareImageName: "bigfive_sq", author: "Author Name"),
        Test(name: "Enneagram", bannerImageName: "enneagram_ft", squareImageName: "enneagram_sq", author: "Author Name"),
        Test(name: "Career Leaders", bannerImageName: "careerleaders_ft", squareImageName: "careerleaders_sq", author: "Author Name")
    ]
}

struct Question: Identifiable, Hashable, Codable {
    let id = UUID()
    let question: String
    var response: String?
}


struct Category: Hashable {
    let name: String
    let tests: [Test]
    
    static let allCategories: [Category] = [
        Category(name: "Popular",
                 tests: [Test(name: "16 Personality", bannerImageName: "16personality_ft", squareImageName: "16personality_sq", author: "Author Name"),
                         Test(name: "Big Five", bannerImageName: "bigfive_ft", squareImageName: "bigfive_sq", author: "Author Name"),
                         Test(name: "Enneagram", bannerImageName: "enneagram_ft", squareImageName: "enneagram_sq", author: "Author Name"),
                         Test(name: "Career Leaders", bannerImageName: "careerleaders_ft", squareImageName: "careerleaders_sq", author: "Author Name")]),
        Category(name: "New Releases",
                 tests: [Test(name: "16 Personality", bannerImageName: "16personality_ft", squareImageName: "16personality_sq", author: "Author Name"),
                         Test(name: "Big Five", bannerImageName: "bigfive_ft", squareImageName: "bigfive_sq", author: "Author Name"),
                         Test(name: "Enneagram", bannerImageName: "enneagram_ft", squareImageName: "enneagram_sq", author: "Author Name"),
                         Test(name: "Career Leaders", bannerImageName: "careerleaders_ft", squareImageName: "careerleaders_sq", author: "Author Name")])
    ]
}
