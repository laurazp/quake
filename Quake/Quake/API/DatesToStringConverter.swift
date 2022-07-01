
import Foundation

class DatesToStringConverter {
    
    let dateFormatterGet = DateFormatter()
    let endTime = Date.now
    
    func getStartTimeString() -> String {
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let startTime = Calendar.current.date(byAdding: .day, value: -30, to: endTime) ?? Date.distantPast
        let startTimeString = dateFormatterGet.string(from: startTime)
        return startTimeString
    }
    
    func getEndTimeString() -> String {
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let endTimeString = dateFormatterGet.string(from: endTime)
        return endTimeString
    }
}
