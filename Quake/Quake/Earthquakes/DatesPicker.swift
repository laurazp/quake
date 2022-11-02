import UIKit

class DatesPicker: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var didSelectDates: ((_ start: Date, _ end: Date) -> Void)?
    
    var selectedDatesString = ""
    var selectedDates = [Date]()
    
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
        startDate = setDays()
        endDate = setDays()
    }
        
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return startDate.count
        case 1:
            return endDate.count
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
        else { return }
        
        let startDay = startDate[startDayIndex]
        let endDay = endDate[endDayIndex]
        
        didSelectDates?(startDay, endDay)
        self.selectedDatesString = returnDates(startDate: startDay, endDate: endDay)
        self.selectedDates = [startDay, endDay]
    }
    
    // Dates shown in DatePickers
    private func getDays(of date: Date) -> [Date] {
        var dates = [Date]()
        
        let calendar = Calendar.current
        
        // first date
        var currentDate = date
        
        // substracting 60 days to current date
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

extension Date {
    
    static func buildTimeRangeString(startDate: Date, endDate: Date) -> String {
        let dayFormatter = DateFormatter()
        dayFormatter.timeStyle = .none
        dayFormatter.dateStyle = .short
        dayFormatter.dateFormat = "MMM dd, yyyy"
        let finalStartDate = dayFormatter.string(from: startDate)
        let finalEndDate = dayFormatter.string(from: endDate)
        
        return String(format: "\(finalStartDate) - \(finalEndDate)")
    }
}
