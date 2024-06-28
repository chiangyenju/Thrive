import SwiftUI

struct ChatView: View {
    @SwiftUI.Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.messages) { message in
                        HStack {
                            if message.isFromUser {
                                Spacer()
                                Text(message.content)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 10)
                            } else {
                                Text(message.content)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .padding(.leading, 10)
                                Spacer()
                            }
                        }
                    }
                }
            }
            .padding(.top, 10)
            .onTapGesture {
                dismissKeyboard()
            }

            HStack {
                TextField("Type a message", text: $viewModel.currentMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 30)
                Button(action: viewModel.sendMessage) {
                    Text("Send")
                }
            }
            .padding()
        }
        .navigationBarHidden(true) // Hide the app name at the top
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.blue)
        })
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                EmptyView() // Hide the tab bar at the bottom
            }
        }
    }

    private func dismissKeyboard() {
        UIApplication.shared.endEditing(true)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
