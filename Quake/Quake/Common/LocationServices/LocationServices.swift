
import Foundation
import CoreLocation
import UIKit

class LocationServices {
    private let locationManager = CLLocationManager()
    
    func checkLocationServices(controller: UIViewController) {
        guard CLLocationManager.locationServicesEnabled() else {
            let alert = UIAlertController(title: "Location Services not enabled", message: "Turning on location services allows us to pinpoint you in the world map so you can see earthquakes around you.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            controller.present(alert, animated: true, completion: nil)
            return
        }
        
        locationManager.delegate = controller as? any CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let alert = UIAlertController(title: "Location Services enabled", message: "Location Services enabled for Quake.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Accept", style: UIAlertAction.Style.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
        checkAuthorizationForLocation(controller: controller)
    }
    
    func checkAuthorizationForLocation(controller: UIViewController) {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .denied:
            let alert = UIAlertController(title: "Location Services not enabled", message: "Turning on location services allows us to pinpoint you in the world map so you can see earthquakes around you.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            controller.present(alert, animated: true, completion: nil)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            let alert = UIAlertController(title: "Alert", message: "Quake is not authorize to use location services. Turning on location services allows us to pinpoint you in the world map so you can see earthquakes around you. Go to your phone Settings to change it.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            controller.present(alert, animated: true, completion: nil)
            break
        @unknown default:
            break
        }
    }
}
