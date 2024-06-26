import SwiftUI

struct TestDetailView: View {
    let test: Test

    var body: some View {
        VStack {
            Image(test.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 250)
                .clipped()
                .cornerRadius(10)
                .shadow(radius: 10)
            
            Text(test.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Spacer()
        }
        .navigationTitle(test.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TestDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TestDetailView(test: Test.example)
    }
}
