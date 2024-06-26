import SwiftUI

struct TestCardView: View {
    let test: Test

    var body: some View {
        NavigationLink(destination: TestDetailView(test: test)) {
            VStack {
                Image(test.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 200)
                    .clipped()
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(test.name)
                        .font(Font.custom("LexendDeca-Regular", size: 14))
                        .fontWeight(.bold)
                        .lineLimit(1)
                    
                    Text("by Author Name") // Replace with actual author name
                        .font(Font.custom("LexendDeca-Regular", size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                .padding(.horizontal, 8)
                .frame(width: 150)
            }
        }
        .buttonStyle(PlainButtonStyle()) // Remove default button styling
    }
}
