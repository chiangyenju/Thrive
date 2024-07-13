import SwiftUI

struct TestResultRowView: View {
    let testResult: TestResult

    var body: some View {
        HStack(spacing: 15) {
            Image(testResult.testIconPic)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipped()
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(testResult.testName)
                        .font(Font.custom("LexendDeca-Regular", size: 16))
                        .fontWeight(.bold)
                    Spacer()
                    Text(formatDate(testResult.date))
                        .font(Font.custom("LexendDeca-Regular", size: 14))
                        .foregroundColor(.gray)
                }

                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                    Text(testResult.conductedByUsername)
                        .font(Font.custom("LexendDeca-Regular", size: 14))
                        .foregroundColor(.gray)
                    Spacer()
                    Text(testResult.mainTestResult)
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

//struct TestResultRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestResultRowView(testResult: TestResult.exampleTestResults[0])
//            .previewLayout(.sizeThatFits)
//    }
//}
