import SwiftUI

struct ChatDetailView: View {
    let messages: [ChatMessage]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(messages) { message in
                    HStack {
                        if message.isFromUser {
                            Spacer()
                            Text(message.content)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        } else {
                            Text(message.content)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Chat Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}


