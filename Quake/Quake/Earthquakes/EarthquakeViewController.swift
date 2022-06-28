
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
        getData(completion: anonymousFunction)
    }

    private func setupTable() {
        tableView.register(UINib(nibName: "EarthquakeEventCell", bundle: nil), forCellReuseIdentifier: "EarthquakeEventCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    
    struct Response: Codable {
        let features: [Feature]
    }

    struct Feature: Codable {
        let properties: Property
        let geometry: Geometry
    }
            
    struct Property: Codable {
        let mag: Double
        let place: String
        let time: Date
        let tsunami: Int
        let title: String
    }
            
    struct Geometry: Codable {
        let coordinates: [Float]
    }

    private func getData(completion: @escaping ([Feature])-> ()) {
                
        let url = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=2014-01-01&endtime=2014-01-02"
                
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
        tableView.reloadRows(at: [indexPath], with: .automatic)
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
            
            let selectedEarthquakeDetail = EarthquakeDetail(title: properties.title,
                                                            place: properties.place,
                                                            time: properties.time,
                                                            tsunami: properties.tsunami,
                                                            coords: geometry.coordinates,
                                                            magnitude: properties.mag)
            
            viewController.earthquakeDetail = selectedEarthquakeDetail
            navigationController?.pushViewController(viewController, animated: true) // Navegacion
            //present(viewController, animated: true) // Modal (pantalla de abajo a arriba)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}
