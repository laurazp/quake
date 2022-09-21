
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
    
    private let datesPicker = DatesPicker()
    
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
    
    // Versión para una sola fecha
//    func filterEarthquakesByDate(selectedDate: Date) {
//        getEarthquakesUseCase.getEarthquakesByDate(selectedDate) { features in
//            self.filteredEarthquakes = features.map { feature in
//                return self.featureToEarthquakeModelMapper.map(from: feature)
//            }
//            self.viewDelegate?.updateView()
//        }
//
//        print(filteredEarthquakes)
//        isFiltering = true
//        self.viewDelegate?.updateView()
//    }
    
    func filterEarthquakesByDate(selectedDates: [Date]) {
        print(selectedDates[0])
        print(selectedDates[1])
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let date1 = formatter.string(from: selectedDates[0])
        let date2 = formatter.string(from: selectedDates[1])
        print(date1)
        print(date2)
        
        
        if date1 == date2 {
            print("iguales!")
            getEarthquakesUseCase.getEarthquakesByDate(selectedDates[0]) { features in
                self.filteredEarthquakes = features.map { feature in
                    return self.featureToEarthquakeModelMapper.map(from: feature)
                }
                self.viewDelegate?.updateView()
            }
            //print(filteredEarthquakes)
            isFiltering = true
            self.viewDelegate?.updateView()
        } else {
            getEarthquakesUseCase.getEarthquakesBetweenDates(selectedDates[0], selectedDates[1]) { features in
                self.filteredEarthquakes = features.map { feature in
                    return self.featureToEarthquakeModelMapper.map(from: feature)
                }
                self.viewDelegate?.updateView()
            }

            //print(filteredEarthquakes)
            isFiltering = true
            self.viewDelegate?.updateView()
        }
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
}
