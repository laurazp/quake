//
//  EarthquakeViewController.swift
//  Quake
//
//  Created by Laura Zafra Prat on 12/6/22.
//

import UIKit

class EarthquakeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var earthquakesData = [Feature]()

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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EarthquakeEventCell", bundle: nil), forCellReuseIdentifier: "EarthquakeEventCell")
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
                    
            //print(json.type)
            print(json.features)
            // Closure calling
            completion(json.features)
                    
        })
            task.resume()
    }

}

extension EarthquakeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earthquakesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EarthquakeEventCell", for: indexPath) as? EarthquakeEventCell else { return UITableViewCell() }
        cell.label.text = earthquakesData[indexPath.row].properties.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Header"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "EarthquakeDetailStoryboard", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "EarthquakeDetailViewController")
        viewController.title = "Detail"
//        navigationController?.pushViewController(viewController, animated: true) // Navegacion
        present(viewController, animated: true) // Modal
    }
}
