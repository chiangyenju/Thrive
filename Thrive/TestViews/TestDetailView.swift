import SwiftUI

struct TestDetailView: View {
    let test: Test

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(test.bannerImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.top, 10) // Add top padding to ensure it doesn't overlap with navigation bar

                Text(test.name)
                    .font(Font.custom("LexendDeca-ExtraBold", size: 24))
                    .padding(.bottom, 5)

                Text("by \(test.author)")
                    .font(Font.custom("LexendDeca-Light", size: 16))
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)

                Text("Description of the test goes here. This section can contain detailed information about the test, its purpose, and other relevant details. The description is long enough to ensure it doesn't get cut off.")
                    .font(Font.custom("LexendDeca-Regular", size: 16))
                    .padding(.bottom, 20)
                    .fixedSize(horizontal: false, vertical: true) // Ensure the text doesn't get cut off

                Button(action: {
                    // Action for taking the test
                    takeTest()
                }) {
                    Text("Take Test")
                        .font(Font.custom("LexendDeca-Regular", size: 18))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }

                Button(action: {
                    // Action for peer test
                    generatePeerTestLink()
                }) {
                    Text("Peer Test")
                        .font(Font.custom("LexendDeca-Regular", size: 18))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.secondary)
                        .cornerRadius(10)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle(test.name)
        .navigationBarTitleDisplayMode(.inline) // Ensure the navigation bar title is displayed inline
    }

    private func takeTest() {
        // Implement the action for taking the test
        print("Take Test action")
    }

    private func generatePeerTestLink() {
        // Implement the action for generating a peer test link
        print("Generate Peer Test Link action")
    }
}

struct TestDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TestDetailView(test: Test.example)
    }
}
