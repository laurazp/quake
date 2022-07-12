
import UIKit

class EarthquakeViewController: UIViewController, EarthquakeEventCellDelegate {
    
    @IBOutlet var tableView: UITableView!
    private var sections = [EarthquakeEventCell]()
    
    var earthquakesData = [Feature]()
    var myIndex = 0
    
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
            })
            self.tableView.endUpdates()
    }
}

extension EarthquakeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earthquakesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EarthquakeEventCell", for: indexPath) as? EarthquakeEventCell else { return UITableViewCell() }
        cell.label.text = earthquakesData[indexPath.row].properties.title
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
