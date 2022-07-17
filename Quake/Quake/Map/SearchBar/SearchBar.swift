
import Foundation
import UIKit

class SearchBar {
    
    func setupSearchBar(resultSearchController: UISearchController) -> UISearchBar {
        let searchBar = resultSearchController.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        //searchBar.showsSearchResultsButton = true
        
        return searchBar
    }
    
}
