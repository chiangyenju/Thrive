import SwiftUI

struct TestDetailView: View {
    let test: Test
    @SwiftUI.Environment(\.presentationMode) var presentationMode
    @State private var apiKey: String? // State variable to hold the API key

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Image(test.bannerImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.top, 10)

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
                        .fixedSize(horizontal: false, vertical: true)

                    NavigationLink(destination: ChatView()) {
                        Text("Take Test")
                            .font(Font.custom("LexendDeca-Regular", size: 18))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle()) // Ensure the NavigationLink behaves like a button

                    Button(action: {
                        generatePeerTestLink() // Implement this function
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
            })
        }
        .navigationBarBackButtonHidden(true) // Hide the default back button
    }

    private func generatePeerTestLink() {
        print("Generate Peer Test Link action") // Placeholder, implement your logic here
    }
}

struct TestDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TestDetailView(test: Test.example)
    }
}
