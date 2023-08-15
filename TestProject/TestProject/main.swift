import Combine
import SwiftUI

func address(of object: UnsafeRawPointer) -> String{
    let address = Int(bitPattern: object)
    return String(format: "%p", address)
}


var tes = [1, 2, 3, 4]
print(address(of: &tes[0]))
print(address(of: &tes[0]))
print(address(of: &tes[1]))
print(address(of: &tes[2]))

