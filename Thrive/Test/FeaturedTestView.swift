import SwiftUI

struct FeaturedTestView: View {
    let tests: [Test]
    @Binding var isTabBarHidden: Bool // Binding to control tab bar visibility

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(tests) { test in
                    NavigationLink(destination: TestDetailView(test: test, isTabBarHidden: $isTabBarHidden)) {
                        FeaturedTestItemView(test: test)
                    }
                }
                .padding([.leading, .trailing])
            }
        }
    }
}

struct FeaturedTestView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedTestView(tests: Test.exampleTests, isTabBarHidden: .constant(false))
    }
}

struct FeaturedTestItemView: View {
    let test: Test

    var body: some View {
        Image(test.bannerImageName ?? "defaultImage_ft")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 300, height: 200)
            .clipped()
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}
