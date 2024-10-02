import Foundation


let dateString = "2024-09-17T17:27:02.142157075"


// DateFormatter를 사용하여 정확한 형식을 지정
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

if let date = dateFormatter.date(from: dateString) {
    print("Converted Date: \(date)")
} else {
    print("Failed to convert date string to Date object")
}
