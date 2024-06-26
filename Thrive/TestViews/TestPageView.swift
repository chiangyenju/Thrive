import SwiftUI

struct TestPageView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) { // Increased spacing between VStack elements
                    // Featured Test
                    Text("Featured")
                        .font(Font.custom("LexendDeca-ExtraBold", size: 20))
                        .fontWeight(.bold)
                        .padding(.leading)
                    
                    FeaturedTestView(tests: Test.exampleTests)
                        .padding([.leading, .trailing])
                        .frame(height: 270) // Adjust height to match FeaturedTestView

                    Divider() // Divider line between sections
                    
                    // Categories
                    ForEach(Category.allCategories, id: \.self) { category in
                        VStack(alignment: .leading) {
                            Text(category.name)
                                .font(Font.custom("LexendDeca-ExtraBold", size: 18))
                                .padding(.leading)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(category.tests) { test in
                                        NavigationLink(destination: TestDetailView(test: test)) {
                                            TestCardView(test: test)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding([.leading, .trailing])
                            }
                        }
                        .padding(.bottom)
                        Divider() // Divider line between categories
                    }
                }
                .padding(.vertical, 20) // Additional vertical padding for overall spacing
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Image(systemName: "line.3.horizontal")
                        .font(.headline)
                }
            }
        }
    }
}

// Example Test Model
struct Test: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
    
    static let example = Test(name: "16 Personality", imageName: "16personality_ft")
    static let exampleTests: [Test] = [
        Test(name: "16 Personality", imageName: "16personality_ft"),
        Test(name: "Big Five", imageName: "bigfive_ft"),
        Test(name: "Enneagram", imageName: "enneagram_ft"),
        Test(name: "Career Leaders", imageName: "careerleaders_ft")
    ]
    
}

// Example Category Model
struct Category: Hashable {
    let name: String
    let tests: [Test]
    
    static let allCategories: [Category] = [
        Category(name: "Popular",
                 tests: [Test(name: "16 Personality", imageName: "16personality_sq"),         Test(name: "Big Five", imageName: "bigfive_sq"),
                         Test(name: "Enneagram", imageName: "enneagram_sq"),
                         Test(name: "Career Leaders", imageName: "careerleaders_sq")]),
        Category(name: "New Releases",
                 tests: [Test(name: "16 Personality", imageName: "16personality_sq"),         Test(name: "Big Five", imageName: "bigfive_sq"),
                         Test(name: "Enneagram", imageName: "enneagram_sq"),
                         Test(name: "Career Leaders", imageName: "careerleaders_sq")])
    ]
}

struct TestPageView_Previews: PreviewProvider {
    static var previews: some View {
        TestPageView()
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
