
import Foundation
import UIKit

final class EarthquakesViewModel {
    weak var viewDelegate: EarthquakeViewController?
    
    private let getEarthquakesUseCase = GetEarthquakesUseCase()
    private var earthquakesData = [Feature]()
    var filteredEarthquakes: [Feature] = []
    private let getMagnitudeColorUseCase = GetMagnitudeColorUseCase()
    private var isFiltering: Bool = false
    private var inIncreasingOrder = false
    
    var filteredText: String?
    
    func viewDidLoad() {
        getEarthquakes()
    }
    
    func getFeature(at index: Int) -> Feature {
        if (isFiltering) {
            return filteredEarthquakes[index]
        } else {
            return earthquakesData[index]
        }
    }
    
    func numberOfItems() -> Int {
        if (isFiltering) {
            return filteredEarthquakes.count
        } else {
            return earthquakesData.count
        }
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
    
    func filterEarthquakesByDate(selectedDate: Date) {
        var stringDateToCompare: String = ""
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        let selectedDateString = formatter.string(from: selectedDate)
        isFiltering = true
        
        filteredEarthquakes = earthquakesData.filter({ (feature: Feature) -> Bool in
            if let date = feature.properties.time {
                stringDateToCompare = formatter.string(from: Date(timeIntervalSince1970: Double(date)/1000))
            }
           
            return stringDateToCompare == selectedDateString
        })
        self.viewDelegate?.updateView()
    }
    
    // TODO: resetear la búsqueda y poner isFiltering a false !!! --> cuándo se debe poner a false ???
    func endFiltering() {
        isFiltering = false
    }
    
    func orderFeaturesByMagnitude() {
        if (!inIncreasingOrder) {
            if (isFiltering) {
                filteredEarthquakes.sort(by: { $0.properties.mag ?? 0 < $1.properties.mag ?? 0 })
                inIncreasingOrder = true
            } else {
                earthquakesData.sort(by: { $0.properties.mag ?? 0 < $1.properties.mag ?? 0 })
                inIncreasingOrder = true
            }
            self.viewDelegate?.updateView()
        } else {
            if (isFiltering) {
                filteredEarthquakes.sort(by: { $1.properties.mag ?? 0 < $0.properties.mag ?? 0 })
                inIncreasingOrder = false
            } else {
                earthquakesData.sort(by: { $1.properties.mag ?? 0 < $0.properties.mag ?? 0 })
                inIncreasingOrder = false
            }
            self.viewDelegate?.updateView()
        }
   }
    
    func orderFeaturesByPlace() {
        if (!inIncreasingOrder) {
            if (isFiltering) {
                filteredEarthquakes.sort(by: { $0.properties.place?.lowercased() ?? "" < $1.properties.place?.lowercased() ?? "" })
                inIncreasingOrder = true
            } else {
                earthquakesData.sort(by: { $0.properties.place?.lowercased() ?? "" < $1.properties.place?.lowercased() ?? "" })
                inIncreasingOrder = true
            }
            self.viewDelegate?.updateView()
        } else {
            if (isFiltering) {
                filteredEarthquakes.sort(by: { $1.properties.place?.lowercased() ?? "" < $0.properties.place?.lowercased() ?? "" })
                inIncreasingOrder = false
            } else {
                earthquakesData.sort(by: { $1.properties.place?.lowercased() ?? "" < $0.properties.place?.lowercased() ?? "" })
                inIncreasingOrder = false
            }
            self.viewDelegate?.updateView()
        }
    }
    
    func orderFeaturesByDate() {
        if (!inIncreasingOrder) {
            if (isFiltering) {
                filteredEarthquakes.sort(by: { $0.properties.time ?? 0 < $1.properties.time ?? 0 })
                inIncreasingOrder = true
            } else {
                earthquakesData.sort(by: { $0.properties.time ?? 0 < $1.properties.time ?? 0 })
                inIncreasingOrder = true
            }
            self.viewDelegate?.updateView()
        } else {
            if (isFiltering) {
                filteredEarthquakes.sort(by: { $1.properties.time ?? 0 < $0.properties.time ?? 0 })
                inIncreasingOrder = false
            } else {
                earthquakesData.sort(by: { $1.properties.time ?? 0 < $0.properties.time ?? 0 })
                inIncreasingOrder = false
            }
            self.viewDelegate?.updateView()
        }
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
