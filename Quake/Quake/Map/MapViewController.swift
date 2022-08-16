
import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(_ mapItem: MKMapItem)
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate {
    
    @IBOutlet private var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    private let rangeInMeters: Double = 1000000
    private var annotationsInMap: [AnnotationInMap] = []
    
    let viewModel = MapViewModel()
    
    let getFormattedTitleMapper = GetFormattedTitleMapper()
    
    @IBOutlet weak var searchBarView: UIView!
    
    var resultSearchController: UISearchController? = nil
    var matchingItems: [MKMapItem] = []
    var selectedPin:MKPlacemark? = nil
    
    // borrar????
    let dateFormatter = MyDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        checkLocationServices()
        centerViewOnUser()
        
        mapView.delegate = self
        //viewModel.viewDidLoad() // --> Descomentar para mostrar los pines en el mapa!!!!

        configureSearchBarAndTable()
        addMapTrackingButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // SearchBar and SearchTable configuration
    func configureSearchBarAndTable() {
        guard let locationSearchTable = storyboard?.instantiateViewController(withIdentifier: "LocationSearchTable") as? LocationSearchTable else { return }
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        setupSearchBar()
        
        navigationItem.searchController = resultSearchController
        if let searchBar = resultSearchController?.searchBar {
            searchBarView.addSubview(searchBar)
        }
        navigationItem.title = "Map"
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
    
    func addMapTrackingButton(){
        let image = UIImage(systemName: "location") as UIImage?
        let button   = UIButton(type: UIButton.ButtonType.system) as UIButton
        button.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
        button.setImage(image, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(MapViewController.centerMapOnUserButtonClicked), for:.touchUpInside)
        self.mapView.addSubview(button)
       }

    @objc func centerMapOnUserButtonClicked() {
        self.mapView.setUserTrackingMode( MKUserTrackingMode.follow, animated: true)
        centerViewOnUser()
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
    
    // MARK: - View Model Output
    func updateView(annotationsInMap: [AnnotationInMap]) {
        mapView.addAnnotations(annotationsInMap)
    }
}

extension MapViewController: HandleMapSearch {
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
        view.markerTintColor = annotation.markerTintColor // TODO: Change color of pins in map
        
        let btn = UIButton(type: .detailDisclosure)
        view.rightCalloutAccessoryView = btn
        //TODO: evento al hacer click en detailDisclosure tbn
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let storyboard = UIStoryboard(name: "EarthquakeDetailStoryboard", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "EarthquakeDetailViewController") as? EarthquakeDetailViewController {
            viewController.viewModel.viewDelegate = viewController
        
            if let selectedAnnotation = view.annotation as? AnnotationInMap {
                let selectedEarthquakeDetail = EarthquakeDetail(title: " ",
                                                                place: selectedAnnotation.place,
                                                                time: selectedAnnotation.time!, //TODO: modificar!!
                                                                tsunami: selectedAnnotation.tsunami ?? 0,
                                                                coords: [Float(selectedAnnotation.coordinate.longitude), Float(selectedAnnotation.coordinate.latitude)],
                                                                depth: Float(selectedAnnotation.depth),
                                                                magnitude: selectedAnnotation.mag)
                viewController.viewModel.earthquakeDetail = selectedEarthquakeDetail
                let formattedTitle = getFormattedTitleMapper.getFormattedTitle(titleWithoutFormat: selectedAnnotation.title ?? "Unknown", place: selectedAnnotation.place ?? "Unknown")
                viewController.title = formattedTitle
                navigationController?.pushViewController(viewController, animated: false)
                //present(viewController, animated: true)
            }
            
        }
    }
    
    func dropPinZoomIn(_ mapItem: MKMapItem){
        selectedPin = mapItem.placemark
        let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        let region = MKCoordinateRegion(center: mapItem.placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        resultSearchController?.searchBar.text = mapItem.name
    }
}

