
import UIKit

class EarthquakeViewController: UIViewController, EarthquakeEventCellDelegate {
    
    @IBOutlet var tableView: UITableView!
    private var sections = [EarthquakeEventCell]() // TODO: Unused, remove this
    
    var earthquakesData = [Feature]()
    var myIndex = 0 // TODO: Unused, remove this
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        
        let earthquakesApiDataSource = EarthquakesApiDataSource()
        
        let anonymousFunction = { (fetchedData: [Feature]) in
            DispatchQueue.main.async {
                self.earthquakesData = fetchedData
                self.tableView.reloadData()
            }
        }
        
        // Define and format Dates
        let datesToStringConverter = DatesToStringConverter()
        let startTimeString = datesToStringConverter.getStartTimeString()
        let endTimeString = datesToStringConverter.getEndTimeString()
        
        earthquakesApiDataSource.getData(startTime: startTimeString, endTime: endTimeString, completion: anonymousFunction)
    }

    private func setupTable() {
        tableView.register(UINib(nibName: "EarthquakeEventCell", bundle: nil), forCellReuseIdentifier: "EarthquakeEventCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
    }

    func didExpandCell(isExpanded: Bool, indexPath: IndexPath) {
        self.tableView.beginUpdates()
            let cell = tableView.cellForRow(at: indexPath) as! EarthquakeEventCell
            cell.animate(duration: 0, c: {
                cell.expandableView.layoutIfNeeded()
                
                // Show info in expandableView labels
                let myDateFormatter = MyDateFormatter()
                let formattedDate = myDateFormatter.formatDate(dateToFormat: self.earthquakesData[indexPath.row].properties.time ?? 0000)
                
                cell.placeLabel.text = "Place: \(self.earthquakesData[indexPath.row].properties.place ?? "unknown")"
                cell.timeLabel.text = "Time: \(formattedDate)"
                cell.tsunamiLabel.text = "Tsunami: \(self.earthquakesData[indexPath.row].properties.tsunami ?? 0)"
            })
            self.tableView.endUpdates()
    }
    
    func setTitleAndMagnitude(cell: EarthquakeEventCell, indexPath: IndexPath) {
        let titleSplitFromMagnitude = earthquakesData[indexPath.row].properties.title?.components(separatedBy: "- ")
        cell.label.text = titleSplitFromMagnitude?[(titleSplitFromMagnitude?.count ?? 0) - 1]
        
        let magSubstring = earthquakesData[indexPath.row].properties.title?.prefix(8).prefix(6).suffix(4)
        let magString = magSubstring.map(String.init)
        cell.magLabel.text = magString
        let magColor = getMagnitudeColor(magnitude: earthquakesData[indexPath.row].properties.mag ?? 0)
        
        switch magColor {
        case 1:
            cell.magLabel.textColor = .green
        case 2:
            cell.magLabel.textColor = .orange
        case 3:
            cell.magLabel.textColor = .red
        default:
            cell.magLabel.textColor = .blue
        }
    }
    
    private func getMagnitudeColor(magnitude: Double) -> Int {
        if magnitude < 3 {
            return 1
        }
        else if magnitude >= 3 && magnitude < 5 {
            return 2
        }
        else {
            return 3
        }
    }
}

extension EarthquakeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earthquakesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EarthquakeEventCell", for: indexPath) as? EarthquakeEventCell else { return UITableViewCell() }
        
        setTitleAndMagnitude(cell: cell, indexPath: indexPath)
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Last Earthquakes"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let myIndex = indexPath.row
        let storyboard = UIStoryboard(name: "EarthquakeDetailStoryboard", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "EarthquakeDetailViewController") as? EarthquakeDetailViewController {
            viewController.title = "Detail"
           
            // Passing data to EarthquakeDetailViewController
            let properties = earthquakesData[myIndex].properties
            let geometry = earthquakesData[myIndex].geometry
            let date = Date(timeIntervalSince1970: TimeInterval(properties.time ?? 0) / 1000)
            
            let selectedEarthquakeDetail = EarthquakeDetail(title: properties.title ?? "unknown",
                                                            place: properties.place,
                                                            time: date,
                                                            tsunami: properties.tsunami ?? 0,
                                                            coords: geometry.coordinates,
                                                            magnitude: properties.mag)
            
            viewController.earthquakeDetail = selectedEarthquakeDetail
            navigationController?.pushViewController(viewController, animated: true) // Navegacion
            //present(viewController, animated: true) // Modal (pantalla de abajo a arriba)
        }
    }
}
