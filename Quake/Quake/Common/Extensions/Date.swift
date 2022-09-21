
import Foundation

extension Date {
    func localString(dateStyle: DateFormatter.Style = .medium,
                     timeStyle: DateFormatter.Style = .medium) -> String {
        return DateFormatter.localizedString(
            from: self,
            dateStyle: dateStyle,
            timeStyle: timeStyle)
    }
    
    var startOfDay: Date {
        //        let cal = Calendar(identifier: .gregorian)
        let cal = Calendar(identifier: .iso8601)
        return cal.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        //        let cal = Calendar(identifier: .gregorian)
        let cal = Calendar(identifier: .iso8601)
        return cal.date(bySettingHour: 23, minute: 59, second: 59, of: self) ?? Date.distantPast
    }
    
    var timezone:TimeZone{
        return TimeZone.current
    }
    ///Returns the first instance of the date, e.g. 2018-02-26 00:00:00
    var trueMidnight: Date {
        let cal = Calendar(identifier: .gregorian)
        let midnight = cal.startOfDay(for: self)
        let secondsFromGMT = TimeZone.current.secondsFromGMT()
        print("Daylight savings? \(daylightSavings)")
        return midnight.addingTimeInterval(-Double(secondsFromGMT))
    }
    ///Returns the last instance of the date, e.g. 2018-02-26 23:59:59
    var trueEndOfDay: Date {
        let cal = Calendar(identifier: .gregorian)
        let endOfDay = cal.date(bySettingHour: 23, minute: 59, second: 59, of: self) ?? Date.distantPast
        let secondsFromGMT = TimeZone.current.secondsFromGMT()
        print("Daylight savings? \(daylightSavings)")
        return endOfDay.addingTimeInterval(-Double(secondsFromGMT))
    }
    ///If this var returns true, then daylight savings time is active and an hour of daylight is gained (during the summer).
    var isDaylightSavings:Bool{
        return timezone.daylightSavingTimeOffset(for: self) == 0 ? false : true
    }
    var daylightSavings:Double{
        return isDaylightSavings ? 3600.0 : 0.0
    }
}
