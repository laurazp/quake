
import Foundation

class EarthquakesApiDataSource {
    
    let offset = 1
    enum Constants {
        static let pageSize = 20
    }
        
    func getData(startTime: String, endTime: String, offset: Int, pageSize: Int, completion: @escaping ([Feature])-> ()) {
        
        let actualOffset = offset
        
        //let urlString = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=\(startTime)&endtime=\(endTime)"
        
        let selectedPageSize = getPageSize(pageSize: pageSize)
        
       let urlString = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=\(startTime)&endtime=\(endTime)&limit=\(selectedPageSize)&offset=\(actualOffset)"
       
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "content-type")
        
        GlobalLoader.startLoading()
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Something went wrong...")
                GlobalLoader.stopLoading()
                return
            }
            
            // Have data
            var result: Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
                // Closure calling
                DispatchQueue.main.async {
                    GlobalLoader.stopLoading()
                    completion(result!.features)
                }
            }
            catch {
                GlobalLoader.stopLoading()
                print("Failed to convert \(error)")
            }
        }
        task.resume()
    }
    
    func getPageSize(pageSize: Int) -> Int {
        var finalPageSize = 0
        if pageSize != 20 {
            finalPageSize = pageSize
        } else {
            finalPageSize = Constants.pageSize
        }
        return finalPageSize
    }
}
