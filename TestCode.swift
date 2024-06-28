//import Alamofire
//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        Text("Testing Alamofire")
//            .padding()
//            .onAppear {
//                fetchGitHubUser()
//            }
//    }
//    
//    func fetchGitHubUser() {
//        let url = "https://api.github.com/users/octocat"
//        
//        AF.request(url).responseDecodable(of: GitHubUser.self) { response in
//            switch response.result {
//            case .success(let user):
//                print("User: \(user.login)")
//            case .failure(let error):
//                print("Error: \(error.localizedDescription)")
//            }
//        }
//    }
//}
//
//struct GitHubUser: Decodable {
//    let login: String
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
