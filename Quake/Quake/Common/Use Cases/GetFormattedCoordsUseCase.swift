
import Foundation

struct GetFormattedCoordsUseCase {
    
    func getFormattedCoords(actualCoords: [Float]?) -> String {
        let longitude = actualCoords?[0] ?? 0
        let latitude = actualCoords?[1] ?? 0
        let longitudeString: String
        let latitudeString: String
        let heightString: String
        
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
        
        if let actualHeight = actualCoords?[2] {
            heightString = String(actualHeight) + "Km"
        } else {
            heightString = " "
        }
        
        return "\(longitudeString), \(latitudeString), \(heightString)"
    }
}
