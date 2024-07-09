import SwiftUI
import Combine // Import Combine framework

struct ChatView: View {
    @SwiftUI.Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = ChatViewModel()
    let test: Test // Injected test object from TestDetailView
    @Binding var isTabBarHidden: Bool // Binding to control tab bar visibility
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.messages, id: \.id) { message in
                            MessageView(message: message)
                        }
                    }
                }
                .padding(.top, 10)
                
                HStack {
                    TextEditor(text: $viewModel.currentMessage)
                        .frame(minHeight: 30, maxHeight: 100) // Allows text to wrap to next line
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .fixedSize(horizontal: false, vertical: true) // Allow vertical expansion only

                    
                    Button(action: {
                        viewModel.sendMessage()
                        hideKeyboard() // Hide keyboard when send button is pressed
                    }) {
                        Text("Send")
                    }
                }
                .padding()
            }
            .navigationTitle(test.name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                isTabBarHidden = false // Show the tab bar when dismissing
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
            })
            .onAppear {
                viewModel.startTest(test.name)
                isTabBarHidden = true // Hide the tab bar when this view appears
            }
            .onDisappear {
                isTabBarHidden = false // Ensure tab bar is shown when exiting
            }
            .onTapGesture {
                hideKeyboard()
            }
            .navigationBarHidden(true)
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(test: Test.example, isTabBarHidden: .constant(false))
    }
}
