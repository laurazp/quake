
import Foundation

class EarthquakesApiDataSource {
    
    func getData(startTime: String, endTime: String, completion: @escaping ([Feature])-> ()) {
        
        let urlString = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=\(startTime)&endtime=\(endTime)"
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "content-type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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
        }
        task.resume()
    }
}
