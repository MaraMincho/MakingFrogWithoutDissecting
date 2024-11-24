import UIKit

let str = "2025-01-15T21:57:58.678717344"

let formatter = DateFormatter()
formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
let targetStr = String(str.prefix(19))
print(formatter.date(from: str)?.description ?? "")
