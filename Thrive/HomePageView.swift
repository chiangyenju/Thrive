import SwiftUI

struct HomePageView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Spacer()
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
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    NavigationLink(destination: ChatListView().environmentObject(ChatViewModel())) {
                        Image(systemName: "message.fill")
                            .font(.headline)
                    }
                }
            }
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
            .environmentObject(AuthViewModel())
    }
}
