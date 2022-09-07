import UIKit

class DatesPicker: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Reference from https://stackoverflow.com/questions/40878547/is-it-possible-to-have-uidatepicker-work-with-start-and-end-time
    
    var didSelectDates: ((_ start: Date, _ end: Date) -> Void)?
    
    var selectedDates = ""
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private var startDate = [Date]()
    private var endDate = [Date]()
    
    let dayFormatter = DateFormatter()
    private let getDateFormatter = GetDateFormatter()
    
    var inputView: UIView {
        return pickerView
    }
    
    func setup() {
        dayFormatter.dateFormat = "dd MMM YYYY"
        //timeFormatter.timeStyle = .short
        startDate = setDays()
        endDate = setDays()
    }
    
    // MARK: - UIPickerViewDelegate & DateSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return startDate.count
        case 1:
            return endDate.count
            //case 2:
            //return endTimes.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        
        var text = ""
        
        switch component {
        case 0:
            text = getDayString(from: startDate[row])
        case 1:
            text = getDayString(from: endDate[row])
        default:
            break
        }
        
        label.text = text
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let startDayIndex = pickerView.selectedRow(inComponent: 0)
        let endDayIndex = pickerView.selectedRow(inComponent: 1)
        
        guard startDate.indices.contains(startDayIndex),
              endDate.indices.contains(endDayIndex)
                //startTimes.indices.contains(startTimeIndex),
                //endTimes.indices.contains(endTimeIndex)
        else { return }
        
        let startDay = startDate[startDayIndex]
        let endDay = endDate[endDayIndex]
        
        didSelectDates?(startDay, endDay)
        self.selectedDates = returnDates(startDate: startDay, endDate: endDay)
    }
    
    // MARK: - Private helpers
    
    // Dates shown in DatePickers
    private func getDays(of date: Date) -> [Date] {
        var dates = [Date]()
        
        let calendar = Calendar.current
        
        // first date
        var currentDate = date
        
        // substracting 60 days to current date ¿¿¿¿¿ añadir más tiempo ?????
        let twoMonthsToNow = calendar.date(byAdding: .day, value: -60, to: currentDate)
        
        // last date
        let endDate = twoMonthsToNow

        while currentDate >= endDate! {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        }
        
        return dates
    }
    
    private func setDays() -> [Date] {
        let today = Date()
        return getDays(of: today)
    }
    
    private func getDayString(from: Date) -> String {
        return dayFormatter.string(from: from)
    }
    
    public func returnDates(startDate: Date, endDate: Date) -> String {
        var dates: String
        let startDate = getDateFormatter.simpleFormatDate(dateToFormat: startDate)
        let endDate =  getDateFormatter.simpleFormatDate(dateToFormat: endDate)
        dates = startDate + " - " + endDate
        
        return dates
    }
}

//TODO: Revisar y añadir credit del chico !!!
extension Date {
    
    static func buildTimeRangeString(startDate: Date, endDate: Date) -> String {
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd MMM yyyy"
        
        //    let startTimeFormatter = DateFormatter()
        //    startTimeFormatter.dateFormat = "h:mm a"
        //
        //    let endTimeFormatter = DateFormatter()
        //    endTimeFormatter.dateFormat = "h:mm a"
        
        //let range = startDate...endDate
        
        return String(format: "\(startDate) - \(endDate)")
        
        //    return String(format: "%@ - %@",
        //                  dayFormatter.string(from: endDate),
        //                  dayFormatter.string(from: startDate))
        //startTimeFormatter.string(from: startDate),
        //endTimeFormatter.string(from: endDate))
    }
}
