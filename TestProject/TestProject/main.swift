import Combine
import SwiftUI



Task {
    for _ in 1...1000 {
        print("🥹", terminator: ", ")
    }
}

Task {
    for _ in 1...1000 {
        print("😡", terminator: ", ")
    }
}

Task {
    for _ in 1...1000 {
        print("✅", terminator: ", ")
    }
}
readLine()

