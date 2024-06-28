import SwiftUI

struct TestPageView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    // Featured Test
                    Text("Featured")
                        .font(Font.custom("LexendDeca-ExtraBold", size: 20))
                        .fontWeight(.bold)
                        .padding(.leading)
                    
                    FeaturedTestView(tests: Test.exampleTests)
                        .padding([.leading, .trailing])
                        .frame(height: 225)
                    
                    // Categories
                    ForEach(Category.allCategories, id: \.self) { category in
                        VStack(alignment: .leading) {
                            Text(category.name)
                                .font(Font.custom("LexendDeca-ExtraBold", size: 20))
                                .padding(.leading)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(category.tests) { test in
                                        NavigationLink(destination: TestDetailView(test: test)) {
                                            TestCardView(test: test)
                                        }
                                    }
                                }
                                .padding([.leading, .trailing])
                            }
                        }
                        .padding(.bottom)
                    }
                }
                .padding(.vertical, 20)
            }
        }
    }
}

// Example Category Model
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

struct TestPageView_Previews: PreviewProvider {
    static var previews: some View {
        TestPageView()
    }
}
