
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
    private var pageNumber = 0
    var hasMoreData = true //Cuando recibamos datos vacíos (arrray), lo ponemos a false y, cuando haya datos, a true. Idealmente, si el num de datos en < que el num de items (20), ya será false
    var isPaginating = true
    var selectedDates = [Date]()
    var filteredText: String?
    
    func viewDidLoad() {
        isPaginating = false
        pageNumber = 0
        getEarthquakes()
    }
    
    func getModel(at index: Int) -> EarthquakeModel {
        if (isFiltering) {
            return filteredEarthquakes[index]
        } else {
            return earthquakesData[index]
        }
    }
    
    func getIndex() -> Int {
        let newIndex = 0 // change
        //TODO: update index
        return newIndex
    }
    
    func numberOfItems() -> Int {
        if (isFiltering) {
            return filteredEarthquakes.count
        } else {
            return earthquakesData.count
        }
    }
    
    func fetchNextPage() {
        isPaginating = true
        if isFiltering {
            filterEarthquakesByDate(selectedDates: selectedDates)
        } else {
            pageNumber += 1
            getEarthquakes()
        }
    }
    
    private func getEarthquakes() {
        //página 0 -> 1   página 1 -> 21  página 2 -> 41
        let offset = pageNumber * EarthquakesApiDataSource.Constants.pageSize + 1
        getEarthquakesUseCase.getLatestEarthquakes(offset: offset, pageSize: 20) { features in
            let earthquakes = features.map { feature in
                return self.featureToEarthquakeModelMapper.map(from: feature)
            }
            
            if self.isPaginating {
                self.earthquakesData.append(contentsOf: earthquakes)
            } else {
                self.earthquakesData = earthquakes
            }
            
            self.hasMoreData = !(earthquakes.count < EarthquakesApiDataSource.Constants.pageSize)
            self.viewDelegate?.updateView()
        }
    }
    
    func getColor(forMagnitude magnitude: Double) -> UIColor {
        return getMagnitudeColorUseCase.getMagnitudeColor(magnitude: magnitude)
    }

    func filterEarthquakesByDate(selectedDates: [Date]) {
        self.selectedDates = selectedDates
        isPaginating = false
        print(selectedDates[0])
        print(selectedDates[1])
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let date1 = formatter.string(from: selectedDates[0])
        let date2 = formatter.string(from: selectedDates[1])
        print(date1)
        print(date2)
        
        let offset = pageNumber * EarthquakesApiDataSource.Constants.pageSize + 1
        
        if date1 == date2 {
            print("iguales!")
            getEarthquakesUseCase.getEarthquakesBetweenDates(selectedDates[0], nil, offset: offset, pageSize: 20) { features in
                self.filteredEarthquakes = features.map { feature in
                    return self.featureToEarthquakeModelMapper.map(from: feature)
                }
                self.viewDelegate?.updateView()
            }
            isFiltering = true
            self.viewDelegate?.updateView()
        } else {
            getEarthquakesUseCase.getEarthquakesBetweenDates(selectedDates[0], selectedDates[1], offset: offset, pageSize: 20) { features in
                self.filteredEarthquakes = features.map { feature in
                    return self.featureToEarthquakeModelMapper.map(from: feature)
                }
                self.pageNumber += 1
                self.viewDelegate?.updateView()
            }
            isFiltering = true
            self.viewDelegate?.updateView()
        }
    }
    
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
                filteredEarthquakes.sort(by: { $0.simplifiedTitle.lowercased().folding(options: .diacriticInsensitive, locale: Locale.current) < $1.simplifiedTitle.lowercased().folding(options: .diacriticInsensitive, locale: Locale.current) })
                inIncreasingOrder = true
            } else {
                earthquakesData.sort(by: { $0.simplifiedTitle.lowercased().folding(options: .diacriticInsensitive, locale: Locale.current) < $1.simplifiedTitle.lowercased().folding(options: .diacriticInsensitive, locale: Locale.current) })
                inIncreasingOrder = true
            }
            self.viewDelegate?.updateView()
        } else {
            if (isFiltering) {
                filteredEarthquakes.sort(by: { $1.simplifiedTitle.lowercased().folding(options: .diacriticInsensitive, locale: Locale.current) < $0.simplifiedTitle.lowercased().folding(options: .diacriticInsensitive, locale: Locale.current) })
                inIncreasingOrder = false
            } else {
                earthquakesData.sort(by: { $1.simplifiedTitle.lowercased().folding(options: .diacriticInsensitive, locale: Locale.current) < $0.simplifiedTitle.lowercased().folding(options: .diacriticInsensitive, locale: Locale.current) })
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
