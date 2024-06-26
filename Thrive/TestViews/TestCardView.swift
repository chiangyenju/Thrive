import SwiftUI

struct TestCardView: View {
    let test: Test

    var body: some View {
        NavigationLink(destination: TestDetailView(test: test)) {
            VStack(alignment: .leading, spacing: 8) {
                Image(test.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 200)
                    .clipped()
                    .cornerRadius(10)
                    .shadow(radius: 5)

                VStack(alignment: .leading, spacing: 4) { // Adjusted spacing for title and author
                    Text(test.name)
                        .font(Font.custom("LexendDeca-Regular", size: 14))
                        .fontWeight(.bold)
                        .lineLimit(1)

                    Text("by Author Name") // Replace with actual author name
                        .font(Font.custom("LexendDeca-Light", size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                .padding(.horizontal, 8) // Horizontal padding for title and author
            }
            .padding(.horizontal, 8) // Horizontal padding for the entire card
            .buttonStyle(PlainButtonStyle()) // Remove default button styling
        }
    }
}
