//
//  Date+Core.swift
//  Core
//
//  Created by Nithi Kulasiriswatdi on 14/5/2564 BE.
//

import Foundation

public extension Date {
    func timeAgo() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current)
    }
}

public extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ssZ", calendar: Calendar = Calendar(identifier: .gregorian)) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.dateFormat = format
        if calendar.identifier == .buddhist {
            dateFormatter.locale = Locale(identifier: "th_TH")
        }
        return dateFormatter.date(from: self)
    }
}
