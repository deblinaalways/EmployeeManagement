//
//  Date + Extension.swift
//  EmployeeManagement
//
//  Created by Deblina Das on 04/05/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    func dateInYYYYMMDDFormat() -> String {
        return DateInternal.dateFormatterForYYYYMMDD.string(from: self)
    }
    
    static func dateFromStringInYYYYMMDDFormat(dateString: String) -> Date? {
        if let date = DateInternal.dateFormatterForYYYYMMDD.date(from: dateString) {
            return date
        } else {
            NSLog("Could not convert date \(dateString) in YYYY-MM-DD format to an NSDate object.")
            return nil
        }
    }
    
    func dateOffset(date: Date) -> Int? {
        guard let dateOffset = Calendar.current.dateComponents([.day], from: date, to: self).day else { return nil }
        return dateOffset
    }
    
    static func dayOfWeek(dateString: String) -> Int? {
        if let date = DateInternal.dateFormatterForYYYYMMDD.date(from: dateString) {
            let calendar = Calendar(identifier: .indian)
            return calendar.component(.weekday, from: date)
        } else {
            NSLog("Could not get weekday from \(dateString).")
            return nil
        }
    }
}

class DateInternal {
    
    static let dateFormatterForYYYYMMDD: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }()
}
