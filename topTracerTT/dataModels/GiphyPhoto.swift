import SwiftUI

struct GiphyPhotos: Codable {
    let data: [GiphyPhoto]
}

struct GiphyPhoto: Codable {
    let username: String
    let title: String
    let images: GiphyOrignalImages
}

struct GiphyOrignalImages: Codable {
    let original: originalImage
}

struct originalImage: Codable {
    let height: String
    let width: String
    let webp: String
    let url: String
}
