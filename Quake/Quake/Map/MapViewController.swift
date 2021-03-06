
import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet private var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    private let rangeInMeters: Double = 1000000
    private var annotationsInMap: [AnnotationInMap] = []
    
    var resultSearchController: UISearchController? = nil
    var matchingItems: [MKMapItem] = []
    var selectedPin:MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
                    
        layoutUI()
        checkLocationServices()
        centerViewOnUser()
        
        mapView.delegate = self
        loadInitialData()
        mapView.addAnnotations(annotationsInMap)
        
        configureSearchBarAndTable()
    }
    
    // SearchBar and SearchTable configuration
    func configureSearchBarAndTable() {
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        setupSearchBar()
        
        navigationItem.searchController = resultSearchController
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
    
    func setupSearchBar() {
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        searchBar.delegate = self
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        /*guard let mapView = mapView,
              let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { searchResponse, _ in
            guard let response = searchResponse else {
                return
            }
            self.matchingItems = response.mapItems
            
            if let center = (self.matchingItems.first?.placemark.region as? CLCircularRegion)?.center {
                
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
                self.mapView.setRegion(region, animated: true)
            }
            
            /*let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(searchBarText) { (placemarks, error) in
                
                if let center = (placemarks?.first?.region as? CLCircularRegion)?.center {
                    
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
                    self.mapView.setRegion(region, animated: true)
                }
            }*/
        }*/
    }
    
    /*func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let mapView = mapView,
              let searchBarText = searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        //TODO: Add a button to start the search
        
        search.start { searchResponse, _ in
            guard let response = searchResponse else {
                return
            }
            self.matchingItems = response.mapItems
            
            if let center = (self.matchingItems.first?.placemark.region as? CLCircularRegion)?.center {
                
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
                self.mapView.setRegion(region, animated: true)
            }
        }
        self.resultSearchController?.isActive = false //Deactivate searchcontroller after search
    }*/
    
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
            // TODO: Here we must tell user how to turn on location on device
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
            // TODO: Here we must tell user how to turn on location on device
            // Show a dialog to tell the user to enable location services
            //locationManager.requestLocation() ??
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
                // TODO: Here we must tell user that the app is not authorize to use location services
            break
        @unknown default:
            break
        }
    }

    private func centerViewOnUser() {
        guard let location = locationManager.location?.coordinate else { return }
        
        let coordinateRegion = MKCoordinateRegion.init(
            center: location,
            latitudinalMeters: rangeInMeters,
            longitudinalMeters: rangeInMeters)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func loadInitialData() {
        let url: String = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson"
        guard let fileName = URL.init(string: url),
              
                let earthquakesData = try? Data(contentsOf: fileName)
        else {
            print("Error retrieving data from url")
            return
        }
        
        do {
            let features = try MKGeoJSONDecoder()
                .decode(earthquakesData)
                .compactMap { $0 as? MKGeoJSONFeature }
            
            let validAnnotations = features.compactMap(AnnotationInMap.init)
            annotationsInMap.append(contentsOf: validAnnotations)
        } catch {
            print("Unexpected error: \(error).")
        }
    }
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
        //Deactivate searchcontroller after search
        self.resultSearchController?.isActive = false
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
            print("error:: (error)")
        }
    
    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        
        guard let annotation = annotation as? AnnotationInMap else {
            return nil
        }
        let identifier = "annotationInMap"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier)
        }
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        view.markerTintColor = annotation.markerTintColor // Change color of pins in map
        return view
    }
}

extension MapViewController: HandleMapSearch {
    
    func dropPinZoomIn(placemark: MKPlacemark){
        selectedPin = placemark
        let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
}
