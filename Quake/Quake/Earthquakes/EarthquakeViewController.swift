
import UIKit

class EarthquakeViewController: UIViewController, EarthquakeEventCellDelegate {
    
    @IBOutlet var tableView: UITableView!
   
    let viewModel = EarthquakesViewModel()
    
    let getFormattedTitleMapper = GetFormattedTitleMapper()
    var getFormattedCoordsUseCase = GetFormattedCoordsUseCase()
    let getTsunamiValueUseCase = GetTsunamiValueUseCase()
    
    var filteredEarthquakes: [Feature] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quake"
        setupTable()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    private func setupTable() {
        tableView.register(UINib(nibName: "EarthquakeEventCell", bundle: nil), forCellReuseIdentifier: "EarthquakeEventCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        viewModel.configureSearchBar(tableView: tableView, navigationItem: navigationItem) // Dates SearchBar
        definesPresentationContext = true

    }
    
    // MARK: - View Model Output
    func updateView() {
        tableView.reloadData()
    }

    func didExpandCell(isExpanded: Bool, indexPath: IndexPath) {
        self.tableView.beginUpdates()
        let cell = tableView.cellForRow(at: indexPath) as! EarthquakeEventCell
        cell.animate(duration: 0, c: {
            cell.expandableView.layoutIfNeeded()
        })
        self.tableView.endUpdates()
    }
    
    func configureCell(cell: EarthquakeEventCell, indexPath: IndexPath) {
        let feature = viewModel.getFeature(at: indexPath.row)
        cell.label.text = getFormattedTitleMapper.getFormattedTitle(titleWithoutFormat: feature.properties.title ?? "Unknown")
   
        let magSubstring = feature.properties.title?.prefix(8).prefix(6).suffix(4)
        let magString = magSubstring.map(String.init)
        cell.magLabel.text = magString
        
        let magnitudeColor = viewModel.getColor(forMagnitude: feature.properties.mag ?? 0)
        cell.magLabel.textColor = magnitudeColor
        
        // Set info for expandableView labels
        let myDateFormatter = MyDateFormatter()
        let formattedDate = myDateFormatter.formatDate(dateToFormat: feature.properties.time ?? 0000)
        let tsunamiValue = getTsunamiValueUseCase.getTsunamiValue(tsunami: feature.properties.tsunami ?? 0)

        cell.placeLabel.text = "Place: \(feature.properties.place ?? "Unknown")"
        cell.timeLabel.text = "Time: \(formattedDate)"
        cell.tsunamiLabel.text = "Tsunami: \(tsunamiValue)"
        cell.coordsLabel.text = "Coords: \(getFormattedCoordsUseCase.getFormattedCoords(actualCoords: feature.geometry.coordinates))"
    }
}

extension EarthquakeViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EarthquakeEventCell", for: indexPath) as? EarthquakeEventCell else { return UITableViewCell() }
        
        configureCell(cell: cell, indexPath: indexPath)
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Last 30 days"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let storyboard = UIStoryboard(name: "EarthquakeDetailStoryboard", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "EarthquakeDetailViewController") as? EarthquakeDetailViewController {
            //viewController.title = "Detail"
            viewController.viewModel.viewDelegate = viewController
            let feature = viewModel.getFeature(at: indexPath.row)
            // Passing data to EarthquakeDetailViewController
            let properties = feature.properties
            let geometry = feature.geometry
            let date = Date(timeIntervalSince1970: TimeInterval(properties.time ?? 0) / 1000)
            
            viewController.title = getFormattedTitleMapper.getFormattedTitle(titleWithoutFormat: feature.properties.title ?? "Unknown")
            
            let selectedEarthquakeDetail = EarthquakeDetail(title: " ",
                                                            place: properties.place,
                                                            time: date,
                                                            tsunami: properties.tsunami ?? 0,
                                                            coords: geometry.coordinates,
                                                            magnitude: properties.mag)
            
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            
            viewController.viewModel.earthquakeDetail = selectedEarthquakeDetail
            navigationController?.pushViewController(viewController, animated: true) // Navegacion
            //present(viewController, animated: true) // Modal (pantalla de abajo a arriba)
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            return 30
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
      // TODO
    }
}
