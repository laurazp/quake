//
//  ViewController.swift
//  Quake
//
//  Created by laurazp on 4/6/22.
//

import UIKit

class ViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
            
    /*struct Response: Codable {
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
    }*/

}


