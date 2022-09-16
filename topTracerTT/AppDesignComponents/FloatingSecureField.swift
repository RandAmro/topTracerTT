import SwiftUI

struct FloatingSecureField: View {
    let title: String
    @Binding var text: String
    @Binding var isValid: Bool
    var style: Style

    @ViewBuilder
    private var titleOverlay: some View {
        GeometryReader { geo in
            if title.isEmpty {
                EmptyView()
            } else {
                Text(title)
                    .foregroundColor(isValid ? style.validColor : style.invalidColor)
                    .opacity(text.isEmpty ? 0 : 1)
                    .offset(y: text.isEmpty ? 0 : -geo.size.height)
                    .scaleEffect(text.isEmpty ? 1 : 0.75, anchor: .topLeading)
                    .animation(text.isEmpty ? .none : .easeOut(duration: 0.3))
            }
        }
    }

    @ViewBuilder
    private var underlineOverlay: some View {
        GeometryReader { reader in
            Rectangle()
                .frame(height: 1)
                .foregroundColor(
                    text.isEmpty ? style.emptyColor : (isValid ? style.validColor : style.invalidColor)
                )
                .offset(x: 0, y: reader.size.height)
        }
    }

    init(
        title: String,
        text: Binding<String>,
        isValid: Binding<Bool> = .constant(true),
        style: Style = Style(
            emptyColor: Color.gray,
            validColor: Color.green,
            invalidColor: Color.red
        )
    ) {
        self.title = title
        self._text = text
        self._isValid = isValid
        self.style = style
    }

    var body: some View {
        SecureField(title, text: $text)
            .overlay(
                titleOverlay
                    .frame(alignment: .leading)
            )
            .overlay(
                underlineOverlay
                    .frame(alignment: .leading)
            )
    }
}

extension FloatingSecureField {
    struct Style {
        var emptyColor: Color
        var validColor: Color
        var invalidColor: Color
    }
}
