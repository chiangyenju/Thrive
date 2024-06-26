import SwiftUI

struct ContentView: View {
    
    @State var selectedTab: Tabs = .home
    
    var body: some View {
        VStack {
            Text("Thrive")
                .padding()
                .font(Fonts.heading)
            Spacer()
            ZStack {
                switch selectedTab {
                case .home:
                    HomePageView()
                case .test:
                    TestPageView()
                case .results:
                    ResultsPageView()
                case .discover:
                    DiscoverPageView()
                case .profile:
                    ProfilePageView()
                }
            }
            Spacer()
            TabBarView(selectedTab: $selectedTab)
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
