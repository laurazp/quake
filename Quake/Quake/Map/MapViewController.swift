
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
    
    private let getFormattedTitleMapper = GetSimplifiedTitleFormatter()
    private let getDateFormatter = GetDateFormatter()
    
    @IBOutlet weak var searchBarView: UIView!
    
    var resultSearchController: UISearchController? = nil
    var matchingItems: [MKMapItem] = []
    var selectedPin:MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        checkLocationServices()
        centerViewOnUser()
        
        mapView.delegate = self
        viewModel.viewDidLoad() // --> Comment/uncomment to show pins on map

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
            // TODO: Revisar mensaje !!!
            let alert = UIAlertController(title: "Location Services not enabled", message: "Go to Permissions in Settings and turn location services on in order to have the whole app working properly.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
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
            let alert = UIAlertController(title: "Location Services not enabled", message: "Go to your phone Settings and turn location services on in order to have the map working properly.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
                // TODO: Revisar mensaje !!!
            let alert = UIAlertController(title: "Alert", message: "Quake is not authorize to use location services. Go to your phone Settings to change it.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
        } else if let cluster = annotation as? MKClusterAnnotation {
            let clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: "clusterView")
                ?? MKAnnotationView(annotation: annotation, reuseIdentifier: "clusterView")
            
            clusterView.annotation = cluster
            clusterView.image = UIImage(named: "cluster") // Hace falta???
            
            return clusterView
        } else {
            view = MKMarkerAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier)
        }
        
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        view.markerTintColor = annotation.markerTintColor // TODO: Change color of pins in map
        view.clusteringIdentifier = "mapItemClustered"
        
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
                let selectedEarthquakeModel = EarthquakeModel(fullTitle: " ",
                                                              simplifiedTitle: selectedAnnotation.title ?? "Unknown",
                                                              place: selectedAnnotation.place ?? "Unknown", formattedCoords: "",
                                                              originalCoords: [Float(selectedAnnotation.coordinate.longitude), Float(selectedAnnotation.coordinate.latitude)],
                                                              depth: String(selectedAnnotation.depth),
                                                              date: getDateFormatter.formatDate(dateToFormat: selectedAnnotation.time!),
                                                              tsunami: String(selectedAnnotation.tsunami ?? 0),
                                                              magnitude: String(selectedAnnotation.mag ?? 0))
                
                viewController.viewModel.earthquakeModel = selectedEarthquakeModel
                let formattedTitle = getFormattedTitleMapper.getSimplifiedTitle(titleWithoutFormat: selectedAnnotation.title ?? "Unknown", place: selectedAnnotation.place ?? "Unknown")
                viewController.title = formattedTitle
                navigationController?.pushViewController(viewController, animated: false)
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

