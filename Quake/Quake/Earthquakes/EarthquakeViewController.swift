
import UIKit

class EarthquakeViewController: UIViewController, EarthquakeEventCellDelegate {
        
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var magnitudeChevron: UIImageView!
    @IBOutlet weak var placeChevron: UIImageView!
    @IBOutlet weak var dateChevron: UIImageView!
    
    let viewModel = EarthquakesViewModel()
    private let featureToEarthquakeModelMapper = FeatureToEarthquakeModelMapper()
    
    let searchController = UISearchController(searchResultsController: nil)
    private let datePicker = UIDatePicker()
    private let datePicker2 = UIDatePicker()

    private lazy var datesPicker: DatesPicker = {
        let picker = DatesPicker()
        picker.setup()
        picker.didSelectDates = { [weak self] (startDate, endDate) in
            let text = Date.buildTimeRangeString(startDate: startDate, endDate: endDate)
            self?.searchController.searchBar.placeholder = text
        }
        return picker
    }()
    
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
        viewModel.viewDidLoad() // Update tableview
    }

    private func setupTable() {
        tableView.register(UINib(nibName: "EarthquakeEventCell", bundle: nil), forCellReuseIdentifier: "EarthquakeEventCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        configureSearchBar() // Dates SearchBar
        definesPresentationContext = true
    }

    private func configureSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Select dates to search"
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.inputView = datesPicker.inputView
        
        // Toolbar
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(filterButtonTapped))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        searchController.searchBar.searchTextField.inputAccessoryView = toolbar
    }
    
    @objc func filterButtonTapped() {
        searchController.searchBar.text = datesPicker.selectedDatesString
        viewModel.filterEarthquakesByDate(selectedDates: datesPicker.selectedDates)
        searchController.searchBar.resignFirstResponder()
      }
    
    @objc func cancelButtonTapped() {
        searchController.searchBar.resignFirstResponder()
        searchBarCancelButtonClicked(searchController.searchBar)
      }
    
    @IBAction func orderByMagnitude(_ sender: Any) {
        rotateMagnitudeChevronImageWhenOrdering()
        viewModel.orderFeaturesByMagnitude()
    }
    
    @IBAction func orderByPlace(_ sender: Any) {
        rotatePlaceChevronImageWhenOrdering()
        viewModel.orderFeaturesByPlace()
    }
    
    @IBAction func orderByDate(_ sender: Any) {
        rotateDateChevronImageWhenOrdering()
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
        let earthquakeModel = viewModel.getModel(at: indexPath.row)
        let magnitudeColor = viewModel.getColor(forMagnitude: Double(earthquakeModel.magnitude) ?? 0)

        cell.label.text = earthquakeModel.simplifiedTitle
        cell.magLabel.text = earthquakeModel.magnitude
        cell.magLabel.textColor = magnitudeColor
        cell.placeLabel.text = "Place: \(earthquakeModel.place)"
        cell.timeLabel.text = "Date: \(earthquakeModel.date)"
        cell.tsunamiLabel.text = "Tsunami: \(earthquakeModel.tsunami)"
        cell.coordsLabel.text = "Coords: \(earthquakeModel.formattedCoords)"
        cell.depthLabel.text = "Depth: \(earthquakeModel.depth)"
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func textFieldShouldReturn(_ textField: UISearchTextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func rotateMagnitudeChevronImageWhenOrdering() {
        UIView.animate(withDuration: 0.2, animations: {
            self.magnitudeChevron.transform = self.magnitudeChevron.transform.rotated(by: .pi)
        })
    }
    
    private func rotatePlaceChevronImageWhenOrdering() {
        UIView.animate(withDuration: 0.2, animations: {
            self.placeChevron.transform = self.placeChevron.transform.rotated(by: .pi)
        })
    }
    
    private func rotateDateChevronImageWhenOrdering() {
        UIView.animate(withDuration: 0.2, animations: {
            self.dateChevron.transform = self.dateChevron.transform.rotated(by: .pi)
        })
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
            viewController.title = "Detail"
            viewController.viewModel.viewDelegate = viewController
            let earthquakeModel = viewModel.getModel(at: indexPath.row)
            
            viewController.title = earthquakeModel.simplifiedTitle

            let selectedEarthquakeModel = EarthquakeModel(fullTitle: " ",
                                                          simplifiedTitle: earthquakeModel.simplifiedTitle,
                                                          place: earthquakeModel.place,
                                                          formattedCoords: earthquakeModel.formattedCoords,
                                                          originalCoords: earthquakeModel.originalCoords,
                                                          depth: earthquakeModel.depth,
                                                          date: earthquakeModel.date,
                                                          originalDate: earthquakeModel.originalDate,
                                                          tsunami: earthquakeModel.tsunami,
                                                          magnitude: earthquakeModel.magnitude)
           
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            
            viewController.viewModel.earthquakeModel = selectedEarthquakeModel
            navigationController?.pushViewController(viewController, animated: true) // Navegacion
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 30
        }
    }
}

extension EarthquakeViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.endFiltering()
        updateView()
        self.searchController.searchBar.placeholder = "Select dates to search"
    }
}
