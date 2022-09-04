
import Foundation
import UIKit

final class EarthquakesViewModel {
    weak var viewDelegate: EarthquakeViewController?
    
    private let getEarthquakesUseCase = GetEarthquakesUseCase()
    private var earthquakesData = [EarthquakeModel]()
    private var filteredEarthquakes: [EarthquakeModel] = []
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
    
    private func getEarthquakes() {
        getEarthquakesUseCase.getLatestEarthquakes { features in
            self.earthquakesData = features.map { feature in
                return self.featureToEarthquakeModelMapper.map(from: feature)
            }
            self.viewDelegate?.updateView()
        }
    }
    
    func getColor(forMagnitude magnitude: Double) -> UIColor {
        return getMagnitudeColorUseCase.getMagnitudeColor(magnitude: magnitude)
    }
    
    // TODO: revisar!!!
    func filterEarthquakesByDate(selectedDate: Date) {
        getEarthquakesUseCase.getEarthquakesByDate(selectedDate) { features in
            self.filteredEarthquakes = features.map { feature in
                return self.featureToEarthquakeModelMapper.map(from: feature)
            }
            self.viewDelegate?.updateView()
        }

        print(filteredEarthquakes)
        isFiltering = true
        self.viewDelegate?.updateView()
    }
    
    // TODO: resetear la búsqueda y poner isFiltering a false??? --> cuándo se debe poner a false ???
    func endFiltering() {
        isFiltering = false
    }
    
    func orderFeaturesByMagnitude() {
        inIncreasingOrder = !inIncreasingOrder
        if (isFiltering) {
            filteredEarthquakes.sort(by: { inIncreasingOrder ? $0.magnitude < $1.magnitude : $0.magnitude > $1.magnitude })
        } else {
            earthquakesData.sort(by: { inIncreasingOrder ? $0.magnitude < $1.magnitude : $0.magnitude > $1.magnitude })
        }
        self.viewDelegate?.updateView()
   }
    
    func orderFeaturesByPlace() {
        if (!inIncreasingOrder) {
            if (isFiltering) {
                filteredEarthquakes.sort(by: { $0.simplifiedTitle.lowercased() < $1.simplifiedTitle.lowercased() })
                inIncreasingOrder = true
            } else {
                earthquakesData.sort(by: { $0.simplifiedTitle.lowercased() < $1.simplifiedTitle.lowercased() })
                inIncreasingOrder = true
            }
            self.viewDelegate?.updateView()
        } else {
            if (isFiltering) {
                filteredEarthquakes.sort(by: { $1.simplifiedTitle.lowercased() < $0.simplifiedTitle.lowercased() })
                inIncreasingOrder = false
            } else {
                earthquakesData.sort(by: { $1.simplifiedTitle.lowercased() < $0.simplifiedTitle.lowercased() })
                inIncreasingOrder = false
            }
            self.viewDelegate?.updateView()
        }
    }
    
    func orderFeaturesByDate() {
        if (!inIncreasingOrder) {
            if (isFiltering) {
                filteredEarthquakes.sort(by: { $0.originalDate < $1.originalDate })
                inIncreasingOrder = true
            } else {
                earthquakesData.sort(by: { $0.originalDate < $1.originalDate })
                inIncreasingOrder = true
            }
            self.viewDelegate?.updateView()
        } else {
            if (isFiltering) {
                filteredEarthquakes.sort(by: { $1.originalDate < $0.originalDate })
                inIncreasingOrder = false
            } else {
                earthquakesData.sort(by: { $1.originalDate < $0.originalDate })
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
