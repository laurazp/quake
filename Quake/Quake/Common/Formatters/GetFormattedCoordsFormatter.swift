
import Foundation

struct GetFormattedCoordsFormatter {
    
    func getFormattedCoords(actualCoords: [Float]?) -> String {
        let longitude = actualCoords?[0] ?? 0
        let latitude = actualCoords?[1] ?? 0
        let longitudeString: String
        let latitudeString: String
        
        if (longitude < 0) {
            longitudeString = String(-(longitude )) + "W"
        } else {
            longitudeString = String((longitude )) + "E"
        }
        
        if (latitude < 0) {
            latitudeString = String(-(latitude )) + "S"
        } else {
            latitudeString = String((latitude )) + "N"
        }
        
        return "\(longitudeString), \(latitudeString)"
    }
}
