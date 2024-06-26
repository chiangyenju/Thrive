import SwiftUI

struct FeaturedTestView: View {
    let tests: [Test]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(tests) { test in
                    NavigationLink(destination: TestDetailView(test: test)) {
                        Image(test.bannerImageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 300, height: 200)
                            .clipped()
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                }
            }
            .padding([.leading, .trailing])
        }
    }
}

struct FeaturedTestView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedTestView(tests: Test.exampleTests)
    }
}
