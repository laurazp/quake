
import Foundation
import MapKit

class AnnotationInMap: NSObject, MKAnnotation {
    
    let title: String?
    let place: String?
    let time: Date?
    let mag: Double?
    let tsunami: Int?
    let coordinate: CLLocationCoordinate2D

      init(
        title: String?,
        place: String?,
        time: Date?,
        mag: Double?,
        tsunami: Int?,
        coordinate: CLLocationCoordinate2D
      ) {
          self.title = title
          self.place = place
          self.time = time
          self.mag = mag
          self.tsunami = tsunami
          self.coordinate = coordinate

          super.init()
      }
    
    init?(feature: MKGeoJSONFeature) {
      // 1
      guard
        let point = feature.geometry.first as? MKPointAnnotation,
        let propertiesData = feature.properties,
        let json = try? JSONSerialization.jsonObject(with: propertiesData),
        let properties = json as? [String: Any]
        else {
          print("Error retrieveing data for map")
          return nil
      }

      // 3
        title = properties["title"] as? String
        place = properties["place"] as? String
        time = properties["time"] as? Date
        mag = properties["mag"] as? Double
        tsunami = properties["tsunami"] as? Int
        coordinate = point.coordinate
        super.init()
    }


      var subtitle: String? {
        return place
      }
    }
