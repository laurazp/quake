
import Foundation

class EarthquakesApiDataSource {
    
    func getData(startTime: String, endTime: String, completion: @escaping ([Feature])-> ()) {
        
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
                DispatchQueue.main.async {
                    completion(result!.features)
                }
            }
            catch {
                print("Failed to convert \(error)")
            }
        })
        task.resume()
    }
}
