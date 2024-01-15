import UIKit


var dict: [String: Int] = [:]
let temp = "1 2 3 4 5".split(separator: " ").map{String($0)}
temp.forEach{val in dict[val] = 3}
dict["1"]
