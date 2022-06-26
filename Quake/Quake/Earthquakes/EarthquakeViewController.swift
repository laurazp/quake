//
//  EarthquakeViewController.swift
//  Quake
//
//  Created by Laura Zafra Prat on 12/6/22.
//

import UIKit

var isOpened: Bool = false

class EarthquakeViewController: UIViewController {
    
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
        tableView.frame = view.bounds
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

    public func expandCells() {
        print("You're inside the expandCells function!")
        isOpened = true
        print("isOpened = " + String(isOpened))
        
    }
    
}

extension EarthquakeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earthquakesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EarthquakeEventCell", for: indexPath) as? EarthquakeEventCell else { return UITableViewCell() }
        cell.label.text = earthquakesData[indexPath.row].properties.title
        //cell.expandableImage.backgroundColor = .blue
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Header"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return earthquakesData.count
    }
    
    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        return tableView.indexPathForSelectedRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Expandable cells testing
        if(isOpened == true) {
            print("Cell is OPENED")
            // Expandable cells test
            isOpened = false
            //tableView.deselectRow(at: indexPath, animated: true)
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
            //tableView.reloadSections([indexPath.section], with: .none)
            //earthquakesData[indexPath.section].isOpened = !earthquakesData[indexPath.section].isOpened
        }
        else {
            print("Cell is CLOSED")
            isOpened = true
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }
        // End of Expandable cells testing
        
        myIndex = indexPath.row
        let storyboard = UIStoryboard(name: "EarthquakeDetailStoryboard", bundle: nil)
        //let viewController = storyboard.instantiateViewController(withIdentifier: "EarthquakeDetailViewController")
        let viewController = EarthquakeDetailViewController()
        viewController.title = "Detail"
        
        // Passing data to EarthquakeDetailViewController
        viewController.titleFromCell = earthquakesData[myIndex].properties.title
        print("Title from cell = " + (viewController.titleFromCell ?? "null"))
        
        navigationController?.pushViewController(viewController, animated: true) // Navegacion
        //present(viewController, animated: true) // Modal (pantalla de abajo a arriba)
        
        
    
    }
}
