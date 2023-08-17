import Combine
import SwiftUI


func getTT() async {
    print("isMainThread? \(Thread.isMainThread)")
}

Task {
    sleep(1)
    await getTT()
}
print("isMainThread? \(Thread.isMainThread)")
await getTT()
readLine()

