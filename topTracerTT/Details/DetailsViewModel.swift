import Foundation
import Combine

enum DetailsViewState {
    case loading, error, success
}

class DetailsViewModel: ObservableObject {
    let username: String
    @Published var giphyOfTheDay: GiphyPhoto?
    var webpImage: String?
    private static let sessionQueue = DispatchQueue(label: "SessionQueue")
    var subscription: Set<AnyCancellable> = []
    @Published var viewState: DetailsViewState = .loading

    init(username: String) {
        self.username = username
    }

    func viewDidLoad() {
        fetchGiphy()
    }


    private func fetchGiphy() {
        let giphyURLString = "https://api.giphy.com/v1/gifs/trending?api_key=5i6f8r55a5sZLFuQTi6XNR5pLi7FRIpx&limit=1&rating=g"
        guard let url = URL(string: giphyURLString) else {
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
        .subscribe(on: Self.sessionQueue)
        .map({
            return $0.data
        })
        .decode(type: GiphyPhotos.self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { (suscriberCompletion) in
            switch suscriberCompletion {
            case .finished:
              // TODO: BACK TO THIS LATER
              break
            case .failure(let error):
                self.viewState = .error
                print(error)
            }
        }, receiveValue: { [weak self] (res) in
            guard let self = self else {
                return
            }
            self.giphyOfTheDay = res.data[0]
            if ((self.giphyOfTheDay?.images.original.webp) != nil) {
                self.webpImage = self.giphyOfTheDay?.images.original.url
                self.viewState = .success
            } else {
                self.viewState = .error
            }

        }).store(in: &subscription)
    }


}
