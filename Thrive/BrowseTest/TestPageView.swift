import SwiftUI

struct TestPageView: View {
    @Binding var isTabBarHidden: Bool // Binding to control tab bar visibility

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    // Featured Test
                    Text("Featured")
                        .font(Font.custom("LexendDeca-ExtraBold", size: 20))
                        .fontWeight(.bold)
                        .padding(.leading)
                    
                    FeaturedTestView(tests: Test.exampleTests, isTabBarHidden: $isTabBarHidden)
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
                                        NavigationLink(destination: TestDetailView(test: test, isTabBarHidden: $isTabBarHidden)) {
                                            TestCardView(test: test, isTabBarHidden: $isTabBarHidden)
                                                .id(test.id) // Ensure each view is uniquely identified
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

struct TestPageView_Previews: PreviewProvider {
    static var previews: some View {
        TestPageView(isTabBarHidden: .constant(false))
    }
}
