
import Foundation

struct GetFormattedCoordsUseCase {
    
    mutating func getFormattedCoords(actualCoords: [Float]?) -> String {
        var formattedCoords: String = " "
        let longitude = actualCoords?[0] ?? 0
        let latitude = actualCoords?[1] ?? 0
        //let actualHeight = actualCoords?[2] ?? 0
        var longitudeString: String
        var latitudeString: String
        var heightString: String
        // TODO: Formatear altura sobre el nivel del mar???
        
        if (longitude < 0) {
            longitudeString = String(-(longitude )) + "W"
        }
        else {
            longitudeString = String((longitude )) + "E"
        }
        let formattedLongitude = longitudeString
        
        if (latitude < 0) {
            latitudeString = String(-(latitude )) + "S"
        }
        else {
            latitudeString = String((latitude )) + "N"
        }
        let formattedlatitude = latitudeString
        
        if let actualHeight = actualCoords?[2] {
            heightString = String(actualHeight) + "Km"
        }
        else {
            heightString = " "
        }
        let formattedHeight = heightString
        
        formattedCoords = "\(formattedLongitude), \(formattedlatitude), \(formattedHeight)"
        return formattedCoords
    }
}
