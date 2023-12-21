//
//  SwiftUIView.swift
//  
//
//  Created by Pavel Kurzo on 19/12/2023.
//

import Foundation
import SwiftUI

private extension DateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}

extension DateFormatter {
    
    /// In this project the language can be set from the application so it can differ from the locale of the phone
    ///
    /// Ex: The user's phone is in Italian and the app is in English
    ///
    /// To avoid having texts tranlated with the locale of the phone and dates translated in another language
    /// the textual  DateFormater are private and only the manulally localized textual DateFormatter can be used in the app

    // Numerical dates
    static let standard = DateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ss")
    static let isoFull = DateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSSSS")
    static let yearMonthDay = DateFormatter(dateFormat: "yyyy-MM-dd")
    static let dayFormatter = DateFormatter(dateFormat: "d")
    static let fullDate = DateFormatter(dateFormat: "EEEE dd MMMM yyyy")
    static let iso8601 = DateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    static let dayMonthYear = DateFormatter(dateFormat: "dd.MM.yyyy")
    // Automatically localized textual dates with the locale of the phone
    static private let weekDay = DateFormatter(dateFormat: "E")
    static private let monthYear = DateFormatter(dateFormat: "MMMM y")
    static private let hourMinute = DateFormatter(dateFormat: "HH:mm")
    
    
    // Manually localized textual dates
    static func weekDayLocalized() -> DateFormatter {
        let dateFormatter = weekDay
        dateFormatter.locale = Locale(identifier: "en_US") // Always use English
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }

    static func completeLocalized() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US") // Always use English
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        return dateFormatter
    }

    static func monthYearLocalized() -> DateFormatter {
        let dateFormatter = monthYear
        dateFormatter.locale = Locale(identifier: "en_US") // Always use English
        return dateFormatter
    }

    static func fullDateLocalized() -> DateFormatter {
        let dateFormatter = fullDate
        dateFormatter.locale = Locale(identifier: "en_US") // Always use English
        return dateFormatter
    }
    static func todayTimeToString(_ date: Date) -> String {
        return (hourMinute.string(from: date))
    }
    
    static func stringAccordingToTheDateFormat(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        } else if now.timeIntervalSince(date) < 7 * 24 * 60 * 60 {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
        }
    }
    
    static func formattedDateDescription(_ date: Date) -> LocalizedStringKey {
        let calendar = Calendar.current
           let now = Date()

           if calendar.isDateInToday(date) {
               // Today
               let formatter = DateFormatter()
               formatter.dateFormat = "HH:mm"
               return "Today at \(formatter.string(from: date))"
           } else if calendar.isDateInYesterday(date) {
               // Yesterday
               let formatter = DateFormatter()
               formatter.dateFormat = "HH:mm"
               return "Yesterday at \(formatter.string(from: date))"
           } else {
               // Older dates
               let components = calendar.dateComponents([.day], from: date, to: now)
               if let daysAgo = components.day {
                   return "\(daysAgo) days ago"
               }
               return "Unknown"
           }
       }
}

extension JSONDecoder {
    
    /// Assign multiple DateFormatter to dateDecodingStrategy
    ///
    /// Usage :
    ///
    ///      decoder.dateDecodingStrategyFormatters = [ DateFormatter.standard, DateFormatter.yearMonthDay ]
    ///
    /// The decoder will now be able to decode as many date format as define by the user
    ///
    /// Throws a 'DecodingError.dataCorruptedError' if an unsupported date format is found while parsing the document
    var dateDecodingStrategyFormatters: [DateFormatter]? {
        @available(*, unavailable, message: "This variable is meant to be set only")
        get { return nil }
        set {
            guard let formatters = newValue else { return }
            self.dateDecodingStrategy = .custom { decoder in
                
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                
                for formatter in formatters {
                    if let date = formatter.date(from: dateString) {
                        return date
                    }
                }
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
            }
        }
    }
}
