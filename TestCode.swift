import SwiftUI

struct TestIconView: View {
    var iconName: String

    var body: some View {
        Image(iconName)
            .resizable()
            .frame(width: 100, height: 100)
            .background(Color.gray)
    }
}

struct TestIconView_Previews: PreviewProvider {
    static var previews: some View {
        TestIconView(iconName: "SquareIcon/16personality_sq")
    }
}
