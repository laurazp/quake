
import UIKit

class EarthquakeViewController: UIViewController, EarthquakeEventCellDelegate {
    
    @IBOutlet var tableView: UITableView!
   
    let viewModel = EarthquakesViewModel()
    
    var getFormattedCoordsUseCase = GetFormattedCoordsUseCase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quake"
        setupTable()
        viewModel.viewDidLoad()
    }

    private func setupTable() {
        tableView.register(UINib(nibName: "EarthquakeEventCell", bundle: nil), forCellReuseIdentifier: "EarthquakeEventCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
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
        if let contains = feature.properties.title?.contains(" of "), contains == true {
            cell.label.text = feature.properties.title?.components(separatedBy: " of ").last
        } else {
            let title = feature.properties.title?.components(separatedBy: " - ")
            cell.label.text = title?.last
        }
        
        let magSubstring = feature.properties.title?.prefix(8).prefix(6).suffix(4)
        let magString = magSubstring.map(String.init)
        cell.magLabel.text = magString
        
        let magnitudeColor = viewModel.getColor(forMagnitude: feature.properties.mag ?? 0)
        cell.magLabel.textColor = magnitudeColor
        
        // Set info for expandableView labels
        let myDateFormatter = MyDateFormatter()
        let formattedDate = myDateFormatter.formatDate(dateToFormat: feature.properties.time ?? 0000)
        
        cell.placeLabel.text = "Place: \(feature.properties.place ?? "Unknown")"
        cell.timeLabel.text = "Time: \(formattedDate)"
        let tsunamiValue = getTsunamiValue(tsunami: feature.properties.tsunami ?? 0)
        cell.tsunamiLabel.text = "Tsunami: \(tsunamiValue)"
        cell.coordsLabel.text = "Coords: \(getFormattedCoordsUseCase.getFormattedCoords(actualCoords: feature.geometry.coordinates))"
    }
    
    private func getTsunamiValue(tsunami: Int) -> String {
        switch (tsunami) {
        case 0:
            return "No"
        case 1:
            return "Yes"
        default:
            return "Unknown"
        }
    }
}

extension EarthquakeViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            
            let titleSplit = properties.title?.components(separatedBy: " of ")
            viewController.title = titleSplit?.last
            
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
    }
}
