import SwiftUI
import SDWebImageSwiftUI

struct DetailsView: View {
    @State var isAnimating: Bool = true
    @ObservedObject var viewModel: DetailsViewModel = DetailsViewModel(username: "")
    @State private var goToLoginView = false

    var body: some View {
        if goToLoginView {
            LoginView(viewModel: LoginViewModel())
        } else {
            VStack(alignment: .center, spacing: 32) {
                Text("Welcome \(viewModel.username)")
                    .font(.system(size: 36, weight: .black, design: .serif))
                    .foregroundColor(.purple)


                if viewModel.viewState == .success {
                    VStack(alignment: .center, spacing: 16) {
                        WebImage(url: URL(string: viewModel.webpImage!), options: [.progressiveLoad], isAnimating: $isAnimating)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Author name: \(viewModel.giphyOfTheDay!.username)")
                                .font(.system(size: 16))
                                .foregroundColor(.black)

                            Text("GIF title: \(viewModel.giphyOfTheDay!.title)")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                        }

                    }

                } else {
                    ProgressView()
                }

                Button(action: {
                    goToLoginView = true
                }) {
                    Text("Logout")
                        .foregroundColor(.purple)
                        .padding([.leading, .trailing], 16)
                        .padding([.top, .bottom], 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(.purple, lineWidth: 2)
                        )
                }
            }.onAppear {
                viewModel.viewDidLoad()
            }.padding(24)
        }
    }
}
