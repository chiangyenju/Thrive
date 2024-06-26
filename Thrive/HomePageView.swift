import SwiftUI

struct HomePageView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            Text("Hi \(authViewModel.user?.email ?? ""), welcome back.")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Button("Log Out") {
                authViewModel.signOut()
            }
            .padding()
        }
    }
}


struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
            .environmentObject(AuthViewModel())
    }
}
