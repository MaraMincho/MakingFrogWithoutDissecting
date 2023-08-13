import Combine
import SwiftUI

//10개의 데이터를 공급할 publisher입니다.
//sink(Subscriber)가 연결되기전까지는 데이터를 발행하지 않습니다.
struct ChatRoom {
    enum Error: Swift.Error {
        case missingConnection
    }
    let subject = PassthroughSubject<String, Error>()
    
    func simulateMessage() {
        subject.send("Hello!")
    }
    
    func simulateNetworkError() {
        subject.send(completion: .failure(.missingConnection))
    }
    
    func closeRoom() {
        subject.send("Chat room closed")
        subject.send(completion: .finished)
    }
}
var beg = Set<AnyCancellable>()
let chatRoom = ChatRoom()
chatRoom.subject.sink { completion in
    switch completion {
    case .finished:
        print("Received finished")
    case .failure(let error):
        print("Received error: \(error)")
    }
} receiveValue: { message in
    print("Received message: \(message)")
}.store(in: &beg)
chatRoom.simulateMessage()
beg.map{$0.cancel()P}
chatRoom.simulateMessage()
