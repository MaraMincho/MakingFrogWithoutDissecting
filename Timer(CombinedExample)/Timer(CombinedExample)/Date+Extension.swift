//
//  String+Extension.swift
//  Timer(CombinedExample)
//
//  Created by MaraMincho on 2023/08/13.
//

import Foundation


extension Date {
    var koreaTime:String {
        get {
            return KSTTimeHelper.formatter.string(from: self)
        }
    }
}


enum KSTTimeHelper {
    static let formatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_kr") // 한국의 시간을 지정해준다.
        formatter.timeZone = TimeZone(abbreviation: "KST") // 한국의 시간대로 지정한다.
        
        return formatter
    }()
}
