
import UIKit

var isOpened: Bool = false

class EarthquakeViewController: UIViewController, EarthquakeEventCellDelegate {
    
    @IBOutlet var tableView: UITableView!
    private var sections = [EarthquakeEventCell]()
    
    var earthquakesData = [Feature]()
    var myIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        
        let anonymousFunction = { (fetchedData: [Feature]) in
            DispatchQueue.main.async {
                self.earthquakesData = fetchedData
                self.tableView.reloadData()
            }
        }
        // Dates
        let endTime = Date.now
        let startTime = Calendar.current.date(byAdding: .day, value: -30, to: endTime) ?? Date.distantPast
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let endTimeString = dateFormatterGet.string(from: endTime)
        let startTimeString = dateFormatterGet.string(from: startTime)
        
        getData(startTime: startTimeString, endTime: endTimeString, completion: anonymousFunction)
    }

    private func setupTable() {
        tableView.register(UINib(nibName: "EarthquakeEventCell", bundle: nil), forCellReuseIdentifier: "EarthquakeEventCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
    }

    private func getData(startTime: String, endTime: String, completion: @escaping ([Feature])-> ()) {
                
        let url = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=\(startTime)&endtime=\(endTime)"
                
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else {
                print("Something went wrong...")
                return
            }
                    
            // Have data
            var result: Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
                // Closure calling
                completion(result!.features)
            }
            catch {
                print("Failed to convert \(error)")
            }

            guard let json = result else {
                return
            }
                    
            print(json.features)
            completion(json.features) // Closure calling
                    
        })
            task.resume()
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
            viewController.title = "Earthquake Detail"
           
            // Passing data to EarthquakeDetailViewController
            let properties = earthquakesData[myIndex].properties
            let geometry = earthquakesData[myIndex].geometry
            let date = Date(timeIntervalSince1970: TimeInterval(properties.time) / 1000)
            
            let selectedEarthquakeDetail = EarthquakeDetail(title: properties.title,
                                                            place: properties.place,
                                                            time: date,
                                                            tsunami: properties.tsunami,
                                                            coords: geometry.coordinates,
                                                            magnitude: properties.mag)
            
            viewController.earthquakeDetail = selectedEarthquakeDetail
            navigationController?.pushViewController(viewController, animated: true) // Navegacion
            //present(viewController, animated: true) // Modal (pantalla de abajo a arriba)
        }
    }
}
