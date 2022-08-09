
import Foundation
import UIKit

final class EarthquakesViewModel {
    weak var viewDelegate: EarthquakeViewController?
    
    private let getEarthquakesUseCase = GetEarthquakesUseCase()
    private var earthquakesData = [Feature]()
    private let getMagnitudeColorUseCase = GetMagnitudeColorUseCase()
    
    //var resultSearchController: UISearchController? = nil
    var filteredEarthquakes: [Feature] = []
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    func viewDidLoad() {
        getEarthquakes()
    }
    
    func getFeature(at index: Int) -> Feature {
        earthquakesData[index]
    }
    
    func numberOfItems() -> Int {
        earthquakesData.count
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
    
    func configureSearchBar(tableView: UITableView, navigationItem: UINavigationItem) {        
        // 1
        searchController.searchResultsUpdater = viewDelegate
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search for dates"
        // 4
        navigationItem.searchController = searchController
        
//        resultSearchController = UISearchController(searchResultsController: viewDelegate)
//        resultSearchController?.searchResultsUpdater = viewDelegate as? UISearchResultsUpdating
//
//        setupSearchBar()
//
//        //navigationItem.searchController = resultSearchController
//        //navigationItem.titleView = resultSearchController?.searchBar
//        resultSearchController?.hidesNavigationBarDuringPresentation = false
//        resultSearchController?.obscuresBackgroundDuringPresentation = true
//        //definesPresentationContext = true
    }
    
    /*func filterContentForSearchDates(initialSearchDate: Date,
                                     finalSearchDate: Date,
                                     time: EarthquakeDetail.time = nil,
                                     tableView: UITableView,
                                     filteredEarthquakes: [Feature]) {
        let range = initialSearchDate...finalSearchDate
        self.filteredEarthquakes = earthquakesData.filter { (feature: Feature) -> Bool in
        return range.contains(feature.properties.time)
      }
      
      tableView.reloadData()
    }*/

    
//    func setupSearchBar() {
//        let searchBar = resultSearchController!.searchBar
//        searchBar.sizeToFit()
//        searchBar.placeholder = "Search for dates"
//        searchBar.delegate = viewDelegate as? UISearchBarDelegate
//    }
}
