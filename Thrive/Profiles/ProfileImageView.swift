import SwiftUI

struct ProfileImageView: View {
    @Binding var image: Image?
    @Binding var imagePickerPresented: Bool
    var onImageSelected: (UIImage) -> Void
    
    var body: some View {
        image?
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
            .padding()
            .frame(width: 150, height: 150)
            .onTapGesture {
                imagePickerPresented = true
            }
    }
}
