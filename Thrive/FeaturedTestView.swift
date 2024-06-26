import SwiftUI

struct FeaturedTestView: View {
    let tests: [Test]
    @State private var currentIndex = 0
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) { // Adjust spacing between banners
                ForEach(tests.indices, id: \.self) { index in
                    NavigationLink(destination: TestDetailView(test: tests[index])) {
                        RoundedRectangle(cornerRadius: 10) // Rounded rectangle shape
                            .fill(Color.white) // White background
                            .frame(width: UIScreen.main.bounds.width - 64, height: 250) // Adjust frame size with padding
                            .overlay(
                                Image(tests[index].imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width - 64, height: 250) // Match parent rounded rectangle size
                                    .cornerRadius(10)
                                    .clipped()
                            )
                            .shadow(color: Color.black.opacity(0.8), radius: 5, x: 2.5, y: 5) // Adjust shadow parameters for a smooth and dimensional effect
                            .transition(.slide) // Slide animation between banners
                            .id(index)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onChange(of: currentIndex) { newValue in
                        withAnimation {
                            currentIndex = newValue
                        }
                    }
                    .gesture(
                        DragGesture(minimumDistance: 10)
                            .onEnded { value in
                                if value.translation.width < 0 {
                                    if currentIndex < tests.count - 1 {
                                        currentIndex += 1
                                    }
                                } else if value.translation.width > 0 {
                                    if currentIndex > 0 {
                                        currentIndex -= 1
                                    }
                                }
                            }
                    )
                }
            }
            .padding(.horizontal, 16) // Padding for left and right edges
            .padding(.vertical, 20) // Add vertical padding to create space around banners
        }
        .onAppear {
            currentIndex = 0 // Start at the first image
        }
    }
}

struct FeaturedTestView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedTestView(tests: Test.exampleTests)
    }
}
