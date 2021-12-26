import Foundation

struct DateUtils {
    static let rawFullDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    }()
    
    static let idDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        return dateFormatter
    }()
    
    static func toFullFormattedString(_ date: Date) -> String {
        return DateUtils.rawFullDateFormatter.string(from: date)
    }
    
    static func fromFullFormattedString(_ stringDate: String) -> Date? {
        return DateUtils.rawFullDateFormatter.date(from: stringDate)
    }
    
    static func toIDFormattedString(_ date: Date) -> String {
        return DateUtils.idDateFormatter.string(from: date)
    }
}
