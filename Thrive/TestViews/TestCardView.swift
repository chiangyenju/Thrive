import SwiftUI

struct TestCardView: View {
    let test: Test

    var body: some View {
        NavigationLink(destination: TestDetailView(test: test)) {
            VStack(alignment: .leading, spacing: 4) {
                Image(test.squareImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 200)
                    .clipped()
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.bottom, 5)

                Text(test.name)
                    .font(Font.custom("LexendDeca-Regular", size: 14))
                    .fontWeight(.bold)
                    .lineLimit(1)

                Text("by \(test.author)")
                    .font(Font.custom("LexendDeca-Light", size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .padding([.leading, .trailing], 8)
            .padding(.top, 8)
            .frame(width: 150, alignment: .leading)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TestCardView_Previews: PreviewProvider {
    static var previews: some View {
        TestCardView(test: Test.example)
            .previewLayout(.sizeThatFits)
    }
}
