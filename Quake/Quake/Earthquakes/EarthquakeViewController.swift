//
//  EarthquakeViewController.swift
//  Quake
//
//  Created by Laura Zafra Prat on 12/6/22.
//

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
        
        // Method calling
        /*getData { data in self.earthquakesData = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
         }*/
    }

    private func setupTable() {
        tableView.register(UINib(nibName: "EarthquakeEventCell", bundle: nil), forCellReuseIdentifier: "EarthquakeEventCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
    }
    
    struct Response: Codable {
        //let type: String
        let features: [Feature]
                
    }

    struct Feature: Codable {
        let properties: Property
        let geometry: Geometry
    }
            
    struct Property: Codable {
        let mag: Double
        let place: String
        //let time: Date
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
            // Closure calling
            completion(json.features)
                    
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
        return "Earthquakes"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let storyboard = UIStoryboard(name: "EarthquakeDetailStoryboard", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "EarthquakeDetailViewController") as? EarthquakeDetailViewController {
            //let viewController = EarthquakeDetailViewController()
            viewController.title = "Detail"
            
            // Passing data to EarthquakeDetailViewController
            viewController.titleFromCell = earthquakesData[myIndex].properties.title
            print("Title from cell = " + (viewController.titleFromCell ?? "null"))
            
            navigationController?.pushViewController(viewController, animated: true) // Navegacion
            //present(viewController, animated: true) // Modal (pantalla de abajo a arriba)
            
        }
    }
}
