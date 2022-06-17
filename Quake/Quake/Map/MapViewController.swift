
import UIKit
import MapKit



class MapViewController: UIViewController, CLLocationManagerDelegate {

    private let mapView = MKMapView(frame: .zero)
    private let locationManager = CLLocationManager()
    private let rangeInMeters: Double = 10000
     
    override func viewDidLoad() {
        super.viewDidLoad()
                    
        layoutUI()
    }
     
    private func layoutUI() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
            
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func checkLocationServices() {
        guard CLLocationManager.locationServicesEnabled() else {
            // Here we must tell user how to turn on location on device
            return
        }
            
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        checkAuthorizationForLocation()
    }

    private func checkAuthorizationForLocation() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            mapView.showsUserLocation = true
            centerViewOnUser()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Here we must tell user how to turn on location on device
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
                // Here we must tell user that the app is not authorize to use location services
            break
        @unknown default:
            break
        }
    }

    private func centerViewOnUser() {
        guard let location = locationManager.location?.coordinate else { return }
        
        let coordinateRegion = MKCoordinateRegion.init(center: location,
                                                       latitudinalMeters: rangeInMeters,
                                                       longitudinalMeters: rangeInMeters)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    /*private func configureMapTypeButton() {
        mapTypeButton.delegate = self
     
        mapTypeButton.addSecondaryButtonWith(image: UIImage(named: "map")!, labelTitle: "Standard", action: {
            self.mapView.mapType = .mutedStandard
        })
            
       mapTypeButton.addSecondaryButtonWith(image: UIImage(named: "satellite")!, labelTitle: "Satellite", action: {
           self.mapView.mapType = .satellite
       })
            
       mapTypeButton.addSecondaryButtonWith(image: UIImage(named: "hybrid")!, labelTitle: "Hybrid", action: {
           self.mapView.mapType = .hybrid
       })
            
       mapTypeButton.setFABButton()
    }*/
    
}



extension MapViewController {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorizationForLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
                let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate,
                                                               latitudinalMeters: rangeInMeters,
                                                               longitudinalMeters: rangeInMeters)
                
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
