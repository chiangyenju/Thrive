import SwiftUI

struct ResultRowView: View {
    let result: Result

    var body: some View {
        HStack(spacing: 15) {
            Image(result.iconName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipped()
                .cornerRadius(10) // Optional: Add corner radius if desired

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(result.testName)
                        .font(Font.custom("LexendDeca-Regular", size: 16))
                        .fontWeight(.bold)
                    Spacer()
                    Text(formatDate(result.date))
                        .font(Font.custom("LexendDeca-Regular", size: 14))
                        .foregroundColor(.gray)
                }

                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                    Text(result.userName)
                        .font(Font.custom("LexendDeca-Regular", size: 14))
                        .foregroundColor(.gray)
                    Spacer()
                    Text(result.mainResult)
                        .font(Font.custom("LexendDeca-Regular", size: 14))
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.vertical, 10)
    }
}

// Helper function to format the date
func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter.string(from: date)
}

struct ResultRowView_Previews: PreviewProvider {
    static var previews: some View {
        ResultRowView(result: Result.exampleResults[0])
            .previewLayout(.sizeThatFits)
    }
}
