import SwiftUI

struct ResultsPageView: View {
    let results = Result.exampleResults

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Results")
                    .font(Font.custom("LexendDeca-ExtraBold", size: 24))
                    .padding([.top, .leading], 20)

                List(results) { result in
                    ResultRowView(result: result)
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ResultsPageView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsPageView()
    }
}
