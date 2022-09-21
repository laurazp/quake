
import Foundation

struct GetTimeRangeUseCase {
    private let dateFormatterGet = DateFormatter()

    func getTimeRange(days: Int) -> (start: String, end: String) {
        (getDateString(date: Date.now, byAddingDays: -days), getDateString(date: Date.now))
    }
    
    func getDateRange(date: Date)  -> (start: String, end: String) {
        (getDateString(date: date.trueMidnight), getDateString(date: date.trueEndOfDay))
    }
    
    func getDateRangeFromDates(startDate: Date, endDate: Date) -> (start: String, end: String) {
        (getDateString(date: startDate), getDateString(date: endDate))
    }
    
    private func getDateString(date: Date, byAddingDays days: Int) -> String {
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let hours = days * 24 - 1
        let startTime = Calendar.current.date(byAdding: .hour, value: hours, to: date) ?? Date.distantPast
        let startTimeString = dateFormatterGet.string(from: startTime)
        return startTimeString
    }
    
    private func getDateString(date: Date) -> String {
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let endTimeString = dateFormatterGet.string(from: date)
        return endTimeString
    }
}
