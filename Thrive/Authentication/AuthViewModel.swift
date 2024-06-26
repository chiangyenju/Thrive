import Foundation
import FirebaseAuth
import Combine

class AuthViewModel: ObservableObject {
    @Published var user: FirebaseAuth.User?
    @Published var isAuthenticated = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let authService = AuthService()

    init() {
        // Subscribe to changes in authentication state
        authService.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.user = user
                self?.isAuthenticated = user != nil
            }
            .store(in: &cancellables)
    }

    func signUp(email: String, password: String) {
        authService.signUp(email: email, password: password) { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else {
                self?.errorMessage = nil
            }
        }
    }

    func login(email: String, password: String) {
        authService.login(email: email, password: password) { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else {
                self?.errorMessage = nil
            }
        }
    }

    func signOut() {
        authService.signOut { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else {
                self?.errorMessage = nil
            }
        }
    }
}
