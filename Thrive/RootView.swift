import SwiftUI
import FirebaseAuth

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                ContentView()
            } else {
                AuthView()
            }
        }
        .onAppear {
            authViewModel.user = Auth.auth().currentUser
            authViewModel.isAuthenticated = authViewModel.user != nil
        }
    }
}
