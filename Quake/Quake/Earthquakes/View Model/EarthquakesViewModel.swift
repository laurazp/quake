
import Foundation
import UIKit

final class EarthquakesViewModel {
    weak var viewDelegate: EarthquakeViewController?
    
    private let getEarthquakesUseCase = GetEarthquakesUseCase()
    private var earthquakesData = [Feature]()
    var filteredEarthquakes: [Feature] = []
    private let getMagnitudeColorUseCase = GetMagnitudeColorUseCase()
    
//    var filteredEarthquakes: [Feature] = []
    
    
    func viewDidLoad() {
        getEarthquakes()
    }
    
    func getFeature(at index: Int) -> Feature {
        earthquakesData[index]
    }
    
    func numberOfItems() -> Int {
        earthquakesData.count
    }
    
    func getEarthquakesData() -> [Feature] {
        return earthquakesData
    }
    
    private func getEarthquakes() {
        getEarthquakesUseCase.getEarthquakes { features in
            self.earthquakesData = features
            self.viewDelegate?.updateView()
        }
    }
    
    func getColor(forMagnitude magnitude: Double) -> UIColor {
        return getMagnitudeColorUseCase.getMagnitudeColor(magnitude: magnitude)
    }
    
    func filterEarthquakesByDate(selectedDate: Date, tableView: UITableView) {
        //var dateToCompare = Date()
        var stringDateToCompare: String = ""
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        let selectedDateString = formatter.string(from: selectedDate)
        
        print("earthquakesData: \(earthquakesData.count)")
        let result = earthquakesData.filter({ (feature: Feature) -> Bool in
            if let date = feature.properties.time {
                stringDateToCompare = formatter.string(from: Date(timeIntervalSince1970: Double(date)/1000))
                //print(stringDateToCompare)
                //print(selectedDateString)
            }
            //return dateToCompare == selectedDate
            print(stringDateToCompare == selectedDateString)
            
            if (stringDateToCompare == selectedDateString) {
                filteredEarthquakes.append(feature)
            }
            
            return stringDateToCompare == selectedDateString
        })
        print("filteredEarthquakes: \(result.count)")
        self.earthquakesData = filteredEarthquakes
        self.viewDelegate?.updateView()
    }
    
//    func filterContentForSearchDates(initialSearchDate: Date,
//                                      finalSearchDate: Date,
//                                    //time: EarthquakeDetail.time? = nil,
//                                      tableView: UITableView) {
//        var dateToCompare = Date()
//        let range = initialSearchDate...finalSearchDate
//        self.filteredEarthquakes = earthquakesData.filter { (feature: Feature) -> Bool in
//            if let date = feature.properties.time {
//                dateToCompare = Date(timeIntervalSince1970: Double(date)/1000)
//                return range.contains(dateToCompare)
//            }
//            return range.contains(dateToCompare)
//        }
//    
//        tableView.reloadData()
//    }
}
