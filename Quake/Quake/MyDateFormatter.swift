
import Foundation

class MyDateFormatter {
    
    let dateFormatter = DateFormatter()
    
    func formatDate(dateToFormat: Date) -> String {
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .long
        //dateFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss a";
        
        let formattedDate = dateFormatter.string(from: dateToFormat)
        
        return formattedDate
    }
    
    func formatDate(dateToFormat: Int64) -> String {
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .long
        
        let dateToFormat = Date(timeIntervalSince1970: Double(dateToFormat)/1000)
        let formattedDate = dateFormatter.string(from: dateToFormat)
        
        return formattedDate
    }
    
    func formatIntToDate(dateToFormat: Int64) -> Date {
        let formattedDate = Date(timeIntervalSince1970: Double(dateToFormat)/1000)
        return formattedDate
    }
}
