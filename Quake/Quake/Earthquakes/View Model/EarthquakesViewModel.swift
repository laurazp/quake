
import Foundation
import UIKit

final class EarthquakesViewModel {
    weak var viewDelegate: EarthquakeViewController?
    
    private let getEarthquakesUseCase = GetEarthquakesUseCase()
    private var featuresData = [Feature]()
    private var earthquakesData = [EarthquakeModel]()
    private var filteredEarthquakes: [EarthquakeModel] = []
    private var filteredFeatures = [Feature]()
    private let getMagnitudeColorUseCase = GetMagnitudeColorUseCase()
    private let featureToEarthquakeModelMapper = FeatureToEarthquakeModelMapper()
    private var isFiltering: Bool = false
    private var inIncreasingOrder = false
    
    var filteredText: String?
    
    func viewDidLoad() {
        getEarthquakes()
    }
    
    func getModel(at index: Int) -> EarthquakeModel {
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
    
    func getEarthquakesData() -> [EarthquakeModel] {
        return earthquakesData
    }
    
    private func getEarthquakes() {
        getEarthquakesUseCase.getEarthquakes { features in
            self.featuresData = features
            
            self.featuresData.forEach {feature in
                let mappedEarthquake = self.featureToEarthquakeModelMapper.map(from: feature)
                self.earthquakesData.append(mappedEarthquake)
            }
            self.viewDelegate?.updateView()
        }
    }
    
    func getColor(forMagnitude magnitude: Double) -> UIColor {
        return getMagnitudeColorUseCase.getMagnitudeColor(magnitude: magnitude)
    }
    
    // TODO: revisar!!!
    func filterEarthquakesByDate(selectedDate: Date) {
        var stringDateToCompare: String = ""
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        let selectedDateString = formatter.string(from: selectedDate)
        isFiltering = true
        
        filteredEarthquakes = earthquakesData.filter({ (earthquake: EarthquakeModel) -> Bool in
            //if let date = earthquake.date { //y si falta??????
            stringDateToCompare = formatter.string(from: Date(timeIntervalSince1970: (Double(earthquake.date) ?? 0)/1000))
            //}
           
            return stringDateToCompare == selectedDateString
        })
        self.viewDelegate?.updateView()
    }
    
    // TODO: resetear la búsqueda y poner isFiltering a false??? --> cuándo se debe poner a false ???
    func endFiltering() {
        isFiltering = false
    }
    
    func orderFeaturesByMagnitude() {
        if (!inIncreasingOrder) {
            if (isFiltering) {
                filteredEarthquakes.sort(by: { $0.magnitude < $1.magnitude })
                inIncreasingOrder = true
            } else {
                earthquakesData.sort(by: { $0.magnitude < $1.magnitude })
                inIncreasingOrder = true
                isFiltering = true
                if (filteredEarthquakes.count == 0) {
                    self.filteredEarthquakes = earthquakesData // ¿¿¿????
                }
            }
            self.viewDelegate?.updateView()
        } else {
            if (isFiltering) {
                filteredEarthquakes.sort(by: { $1.magnitude < $0.magnitude })
                inIncreasingOrder = false
            } else {
                earthquakesData.sort(by: { $1.magnitude < $0.magnitude })
                inIncreasingOrder = false
                isFiltering = true
                if (filteredEarthquakes.count == 0) {
                    self.filteredEarthquakes = earthquakesData
                }
            }
            self.viewDelegate?.updateView()
        }
   }
    
    func orderFeaturesByPlace() {
        if (!inIncreasingOrder) {
            if (isFiltering) {
                filteredEarthquakes.sort(by: { $0.simplifiedTitle.lowercased() < $1.simplifiedTitle.lowercased() })
                inIncreasingOrder = true
            } else {
                earthquakesData.sort(by: { $0.simplifiedTitle.lowercased() < $1.simplifiedTitle.lowercased() })
                inIncreasingOrder = true
                isFiltering = true
                if (filteredEarthquakes.count == 0) {
                    self.filteredEarthquakes = earthquakesData
                }
            }
            self.viewDelegate?.updateView()
        } else {
            if (isFiltering) {
                filteredEarthquakes.sort(by: { $1.simplifiedTitle.lowercased() < $0.simplifiedTitle.lowercased() })
                inIncreasingOrder = false
            } else {
                earthquakesData.sort(by: { $1.simplifiedTitle.lowercased() < $0.simplifiedTitle.lowercased() })
                inIncreasingOrder = false
                isFiltering = true
                if (filteredEarthquakes.count == 0) {
                    self.filteredEarthquakes = earthquakesData
                }
            }
            self.viewDelegate?.updateView()
        }
    }
    
    func orderFeaturesByDate() {
        if (!inIncreasingOrder) {
            if (isFiltering) {
                filteredEarthquakes.sort(by: { $0.date < $1.date })
                inIncreasingOrder = true
            } else {
                earthquakesData.sort(by: { $0.date < $1.date })
                inIncreasingOrder = true
                isFiltering = true
                if (filteredEarthquakes.count == 0) {
                    self.filteredEarthquakes = earthquakesData
                }
            }
            self.viewDelegate?.updateView()
        } else {
            if (isFiltering) {
                filteredEarthquakes.sort(by: { $1.date < $0.date })
                inIncreasingOrder = false
            } else {
                earthquakesData.sort(by: { $1.date < $0.date })
                inIncreasingOrder = false
                isFiltering = true
                if (filteredEarthquakes.count == 0) {
                    self.filteredEarthquakes = earthquakesData
                }
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
