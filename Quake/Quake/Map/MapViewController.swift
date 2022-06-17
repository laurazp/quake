
import UIKit
import MapKit



class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    private let mapView = MKMapView(frame: .zero)
    private let locationManager = CLLocationManager()
    private let rangeInMeters: Double = 10000
    
    private var annotationsInMap: [AnnotationInMap] = []

     
    override func viewDidLoad() {
        super.viewDidLoad()
                    
        layoutUI()
        checkLocationServices()
        centerViewOnUser()
        
        mapView.delegate = self

        // Show custom artwork on map
        /*let annotationInMap = AnnotationInMap(
          title: "King David Kalakaua",
          locationName: "Waikiki Gateway Park",
          discipline: "Sculpture",
          coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
        mapView.addAnnotation(annotationInMap)*/
        
        loadInitialData()
        mapView.addAnnotations(annotationsInMap)

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
    
    private func loadInitialData() {
      // 1
        // TODO: Cambiar este punto 1 por acceso a url de terremotos
      guard
        let fileName = Bundle.main.url(forResource: "Earthquakes", withExtension: "geojson"),
        let earthquakesData = try? Data(contentsOf: fileName)
        else {
          return
      }

      do {
        // 2
        let features = try MKGeoJSONDecoder()
          .decode(earthquakesData)
          .compactMap { $0 as? MKGeoJSONFeature }
        // 3
        let validAnnotations = features.compactMap(AnnotationInMap.init)
        // 4
          annotationsInMap.append(contentsOf: validAnnotations)
      } catch {
        // 5
        print("Unexpected error: \(error).")
      }
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

// TODO Revisar por qué no sale bien el globo de las anotaciones
extension ViewController: MKMapViewDelegate {
  // 1
  func mapView(
    _ mapView: MKMapView,
    viewFor annotation: MKAnnotation
  ) -> MKAnnotationView? {
    // 2
    guard let annotation = annotation as? AnnotationInMap else {
      return nil
    }
    // 3
    let identifier = "annotationInMap"
    var view: MKMarkerAnnotationView
    // 4
    if let dequeuedView = mapView.dequeueReusableAnnotationView(
      withIdentifier: identifier) as? MKMarkerAnnotationView {
      dequeuedView.annotation = annotation
      view = dequeuedView
    } else {
      // 5
      view = MKMarkerAnnotationView(
        annotation: annotation,
        reuseIdentifier: identifier)
      view.canShowCallout = true
      view.calloutOffset = CGPoint(x: -5, y: 5)
      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    return view
  }
}


