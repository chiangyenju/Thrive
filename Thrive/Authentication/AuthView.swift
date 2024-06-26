import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggingIn = true
    @State private var rememberMe = false // New state for remember me

    var body: some View {
        VStack {
            Text("Thrive")
                .font(Font.custom("LexendDeca-ExtraBold", size: 30))
                .padding(.bottom, 20)

            VStack(spacing: 20) {
                TextField("  Email", text: self.$email)
                    .frame(height: 55)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 4)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                    .padding([.horizontal], 24)
                    .font(Font.custom("LexendDeca-Regular", size: 18))

                SecureField("  Password", text: $password)
                    .frame(height: 55)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 4)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                    .padding([.horizontal], 24)
                    .font(Font.custom("LexendDeca-Regular", size: 18))

                Toggle("Remember Me", isOn: $rememberMe)
                    .font(Font.custom("LexendDeca-Regular", size: 14))
                    .padding(.horizontal, 40)
                    .foregroundColor(.primary)

                Button(action: {
                    if isLoggingIn {
                        authViewModel.login(email: email, password: password)
                    } else {
                        authViewModel.signUp(email: email, password: password)
                    }
                }) {
                    Text(isLoggingIn ? "Log In" : "Sign Up")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)

                Button(action: {
                    isLoggingIn.toggle()
                }) {
                    Text(isLoggingIn ? "Don't have an account? Sign Up" : "Already have an account? Log In")
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .frame(maxWidth: 400) // Set a maximum width
            .background(Color(UIColor.systemBackground)) // Use system background color for dark mode compatibility
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            .padding()

            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
        .foregroundColor(.primary) // Ensure primary text color for dark mode
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
            .environmentObject(AuthViewModel())
            .preferredColorScheme(.dark) // Preview in dark mode
    }
}
