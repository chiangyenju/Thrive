import SwiftUI

struct ContentView: View {
    @State var selectedTab: Tabs = .home
    @State var isTabBarHidden: Bool = false // State to control tab bar visibility

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
                    TestPageView(isTabBarHidden: $isTabBarHidden)
                case .results:
                    TestResultPageView()
                case .discover:
                    DiscoverPageView()
                case .profile:
                    ProfilePageView()
                }
            }
            Spacer()
            if !isTabBarHidden {
                TabBarView(selectedTab: $selectedTab)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
