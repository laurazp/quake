
import Foundation
import MapKit

class AnnotationInMap: NSObject, MKAnnotation {
    
    let title: String?
    let place: String?
    let time: Date?
    let mag: Double?
    let tsunami: Int?
    let coordinate: CLLocationCoordinate2D
    let depth: Float
    
    var markerTintColor: UIColor {
        let magLvl = getMagnitudeLevel(magnitude: self.mag ?? 0.0)
        
        switch magLvl {
        case 1:
            return .green
        case 2:
            return .orange
        case 3:
            return .red
        default:
            return .blue
        }
    }

    init(
        title: String?,
        place: String?,
        time: Date?,
        mag: Double?,
        tsunami: Int?,
        coordinate: CLLocationCoordinate2D,
        depth: Float
    ) {
        self.title = title
        self.place = place
        self.time = time
        self.mag = mag
        self.tsunami = tsunami
        self.coordinate = coordinate
        self.depth = depth

        super.init()
    }
    
//    init?(feature: MKGeoJSONFeature) {
//
//        guard let point = feature.geometry.first as? MKPointAnnotation,
//        let propertiesData = feature.properties,
//        let json = try? JSONSerialization.jsonObject(with: propertiesData),
//        let properties = json as? [String: Any]
//        else {
//          print("Error retrieveing data for map")
//          return nil
//        }
//
//        title = properties["title"] as? String
//        place = properties["place"] as? String
//        time = properties["time"] as? Date
//        mag = properties["mag"] as? Double
//        tsunami = properties["tsunami"] as? Int
//        coordinate = point.coordinate
//        depth =
//        super.init()
//    }

    var subtitle: String? {
        return "Magnitude: \(mag ?? 0.0)"
    }
    
    private func getMagnitudeLevel(magnitude: Double) -> Int {
        if magnitude < 3 {
            return 1
        }
        else if magnitude >= 3 && magnitude < 5 {
            return 2
        }
        else {
            return 3
        }
    }
}
