
import UIKit

class EarthquakeViewController: UIViewController, EarthquakeEventCellDelegate {
        
    @IBOutlet var tableView: UITableView!
    
    let viewModel = EarthquakesViewModel() // private??
    private let featureToEarthquakeModelMapper = FeatureToEarthquakeModelMapper()
    
    //revisar???
    let getFormattedTitleMapper = GetSimplifiedTitleFormatter()
    var getFormattedCoordsFormatter = GetFormattedCoordsFormatter()
    let getTsunamiValueFormatter = GetTsunamiValueFormatter()
    private var depthValue: Float = 0
    
    let searchController = UISearchController(searchResultsController: nil)
    private let datePicker = UIDatePicker()
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
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
        configureSearchBar() // Dates SearchBar
        //configureFiltersBar()
        definesPresentationContext = true

    }
    
    private func configureSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Select a date"
        navigationItem.searchController = searchController
        
        //Configure DatePicker
        datePicker.datePickerMode = .date
        datePicker.locale = .current
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        searchController.searchBar.searchTextField.inputView = datePicker
        
        //Create a toolbar with a Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(filterButtonTapped))
        toolbar.setItems([doneButton], animated: true)
        searchController.searchBar.searchTextField.inputAccessoryView = toolbar
    }
    
    @objc func filterButtonTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: datePicker.date)
        searchController.searchBar.text = dateString
        viewModel.filterEarthquakesByDate(selectedDate: datePicker.date)
        //datePicker.resignFirstResponder() <-- no funciona
        searchController.isActive = false //TODO: así está bien ?????
      }
    
    @IBAction func orderByMagnitude(_ sender: Any) {
        viewModel.orderFeaturesByMagnitude()
    }
    
    @IBAction func orderByPlace(_ sender: Any) {
        viewModel.orderFeaturesByPlace()
    }
    
    @IBAction func orderByDate(_ sender: Any) {
        viewModel.orderFeaturesByDate()
    }
    
    // MARK: - View Model Output
    func updateView() {
        tableView.reloadData()
        if let filteredText = viewModel.filteredText {
            searchController.searchBar.text = filteredText
        }
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
//        let feature = viewModel.getFeature(at: indexPath.row)
//
//        cell.label.text = getFormattedTitleMapper.getSimplifiedTitle(titleWithoutFormat: feature.properties.title ?? "Unknown", place: feature.properties.place ?? "Unknown")
//
//        let magSubstring = feature.properties.title?.prefix(8).prefix(6).suffix(4)
//        let magString = magSubstring.map(String.init)
//        cell.magLabel.text = magString
//
//        let magnitudeColor = viewModel.getColor(forMagnitude: feature.properties.mag ?? 0)
//        cell.magLabel.textColor = magnitudeColor
//
//        // Set info for expandableView labels
//        let getDateFormatter = GetDateFormatter()
//        let formattedDate = getDateFormatter.formatDate(dateToFormat: feature.properties.time ?? 0000)
//        let tsunamiValue = getTsunamiValueFormatter.getTsunamiValue(tsunami: feature.properties.tsunami ?? 0)
//        if let depth = feature.geometry.coordinates[2] as? Float {
//            depthValue = depth
//        }
//        //guard let depthValue = feature.geometry.coordinates[2] as? Float else { return }
//
//        cell.placeLabel.text = "Place: \(feature.properties.place ?? "Unknown")"
//        cell.timeLabel.text = "Time: \(formattedDate)"
//        cell.tsunamiLabel.text = "Tsunami: \(tsunamiValue)"
//        cell.coordsLabel.text = "Coords: \(getFormattedCoordsFormatter.getFormattedCoords(actualCoords: feature.geometry.coordinates))"
//        cell.depthLabel.text = "Depth: \(depthValue)km"
        
        let feature = viewModel.getFeature(at: indexPath.row)
        let earthquakeModel = featureToEarthquakeModelMapper.map(from: feature)
        
        let magnitudeColor = viewModel.getColor(forMagnitude: feature.properties.mag ?? 0)

        
        cell.label.text = earthquakeModel.simplifiedTitle
        cell.magLabel.text = earthquakeModel.magnitude
        cell.magLabel.textColor = magnitudeColor
        cell.placeLabel.text = "Place: \(earthquakeModel.place)"
        cell.timeLabel.text = "Date: \(earthquakeModel.date)"
        cell.tsunamiLabel.text = "Tsunami: \(earthquakeModel.tsunami)"
        cell.coordsLabel.text = "Coords: \(earthquakeModel.coords)"
        cell.depthLabel.text = "Depth: \(earthquakeModel.depth)"
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        //viewModel.filterContentForSearchDates(initialSearchDate: searchBar.initialDate, finalSearchDate: searchBar.finalDate, tableView: tableView)
    }
    
    func textFieldShouldReturn(_ textField: UISearchTextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
}

extension EarthquakeViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
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
            
            viewController.title = getFormattedTitleMapper.getSimplifiedTitle(titleWithoutFormat: feature.properties.title ?? "Unknown", place: feature.properties.place ?? "Unknown")
            
            if (geometry.coordinates[2] != nil) {
                depthValue = feature.geometry.coordinates[2]
            }
            
            let selectedEarthquakeDetail = EarthquakeDetail(title: " ",
                                                            place: properties.place,
                                                            time: date,
                                                            tsunami: properties.tsunami ?? 0,
                                                            coords: geometry.coordinates,
                                                            depth: depthValue,
                                                            magnitude: properties.mag)
            
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            
            viewController.viewModel.earthquakeDetail = selectedEarthquakeDetail
            navigationController?.pushViewController(viewController, animated: true) // Navegacion
            //present(viewController, animated: true) // Modal (pantalla de abajo a arriba)
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 30
        }
    }
}
