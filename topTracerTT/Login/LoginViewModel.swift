import Foundation
import Combine

class LoginViewModel: ObservableObject {

    @Published var username = ""
    @Published var password = ""
    lazy var isUsernameValid: AnyPublisher<Bool, Never> = {
        $username.validationPublisher { $0.hasNoNumbersAndEmojies() }
            .eraseToAnyPublisher()
    }()
    lazy var isPasswordValid: AnyPublisher<Bool, Never> = {
        $password.validationPublisher { $0.isValidPassword() }
            .eraseToAnyPublisher()
    }()

    lazy var formValidationStream: AnyPublisher<Bool, Never> = {
        return Publishers
            .CombineLatest(
                isUsernameValid,
                isPasswordValid
            )
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }()

}


extension Published.Publisher where Value: Equatable {
    func validationPublisher(validator: @escaping (Value) -> Bool) -> AnyPublisher<Bool, Never> {
        self
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { validator($0) }
            .eraseToAnyPublisher()
    }
}

extension String {
    func hasNoNumbersAndEmojies() -> Bool {
        return self.count > 0 && !self.containsEmoji() && !hasNumber()
    }

    func containsEmoji() -> Bool {
        for i in self {
            if i.isEmoji() {
                return true
            }
        }
        return false
    }

    func hasNumber() -> Bool {
        let digitSet = CharacterSet.decimalDigits
        for ch in self.unicodeScalars {
            if digitSet.contains(ch) {
               return true
            }
        }
        return  false
    }

    func isValidPassword() -> Bool {
        if self == "password" {
            return true
        }
        return false
    }
}

extension Character {
    func isEmoji() -> Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x3030, 0x00AE, 0x00A9, // Special Characters
            0x1D000...0x1F77F,          // Emoticons
            0x2100...0x27BF,            // Misc symbols and Dingbats
            0xFE00...0xFE0F,            // Variation Selectors
            0x1F900...0x1F9FF:          // Supplemental Symbols and Pictographs
                return true
            default:
                continue
            }
        }
        return false
    }
}
