import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @State private var isUsernameValid: Bool = false
    @State private var isPasswordValid: Bool = false
    @State private var loginButtonIsDisabled = true
    @State private var forgotPasswordButtonClicked = false
    @State private var goToDetailsView = false

    var buttonColor: Color {
        return loginButtonIsDisabled ? .gray : .purple
    }

    var body: some View {

        if goToDetailsView {
            DetailsView(viewModel: DetailsViewModel(username: viewModel.username))
        } else {
            VStack(alignment: .leading, spacing: 32) {
                FloatingTextField(
                    title: "Username",
                    text: $viewModel.username,
                    isValid: $isUsernameValid
                )
                .onReceive(viewModel.isUsernameValid) { self.isUsernameValid = $0 }
                .keyboardType(.namePhonePad)


                FloatingSecureField(
                    title: "Password",
                    text: $viewModel.password,
                    isValid: $isPasswordValid
                )
                .onReceive(viewModel.isPasswordValid) { self.isPasswordValid = $0 }
                .keyboardType(.default)

                HStack (spacing: 32) {
                    Button(action: {
                        forgotPasswordButtonClicked.toggle()
                    }) {
                        Text("Forgot password")
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Button(action: {
                        goToDetailsView = true
                    }) {
                        Text("Login")
                            .foregroundColor(buttonColor)
                            .padding([.leading, .trailing], 16)
                            .padding([.top, .bottom], 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 32)
                                    .stroke(buttonColor, lineWidth: 2)
                            )
                    }
                    .onReceive(viewModel.formValidationStream) {
                        self.loginButtonIsDisabled = !$0
                    }
                    .disabled(loginButtonIsDisabled)
                }

                if forgotPasswordButtonClicked {
                    HStack {
                        Spacer()
                        Text("It's 'password' 🤫")
                            .foregroundColor(.purple)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    forgotPasswordButtonClicked.toggle()
                                }
                            }
                        Spacer()
                    }
                }
            }.padding(24)
        }
    }
}
