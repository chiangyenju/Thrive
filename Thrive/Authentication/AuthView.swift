import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggingIn = true
    @State private var rememberMe = false // Added state for "Remember Me"

    var body: some View {
        VStack {
            Text("Thrive")
                .font(.custom("Lexend Deca", size: 48))
                .foregroundColor(.blue)
                .padding(.bottom, 30)

            VStack(spacing: 20) {
                TextField("Email", text: $email)
                    .font(.title)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 2))
                    .padding(.horizontal, 20)
                    .onAppear {
                        if let savedEmail = UserDefaults.standard.string(forKey: "rememberedEmail") {
                            email = savedEmail
                            rememberMe = true
                        }
                    }

                SecureField("Password", text: $password)
                    .font(.title)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 2))
                    .padding(.horizontal, 20)

                HStack {
                    Toggle("Remember Me", isOn: $rememberMe)
                        .font(.title3)
                        .foregroundColor(.blue)
                        .padding()
                        .onChange(of: rememberMe) { newValue in
                            if !newValue {
                                UserDefaults.standard.removeObject(forKey: "rememberedEmail")
                            }
                        }

                    Spacer()
                }

                Button(action: {
                    if isLoggingIn {
                        authViewModel.login(email: email, password: password)
                    } else {
                        authViewModel.signUp(email: email, password: password)
                    }

                    if rememberMe {
                        UserDefaults.standard.set(email, forKey: "rememberedEmail")
                    } else {
                        UserDefaults.standard.removeObject(forKey: "rememberedEmail")
                    }
                }) {
                    Text(isLoggingIn ? "Log In" : "Sign Up")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }

                Button(action: {
                    isLoggingIn.toggle()
                }) {
                    Text(isLoggingIn ? "Don't have an account? Sign Up" : "Already have an account? Log In")
                        .foregroundColor(.blue)
                        .font(.title3)
                        .padding()
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)

            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.title3)
                    .padding()
            }
        }
        .padding()
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
            .environmentObject(AuthViewModel())
            .preferredColorScheme(.dark)
    }
}
