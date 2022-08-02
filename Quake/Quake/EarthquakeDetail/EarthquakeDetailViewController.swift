
import UIKit
import MapKit

class EarthquakeDetailViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tsunamiLabel: UILabel!
    @IBOutlet weak var coordsLabel: UILabel!
    @IBOutlet weak var magnitudeLabel: UILabel!
    
    var earthquakeDetail: EarthquakeDetail?
    
    // MapView
    @IBOutlet weak var mapView: MKMapView!
//    var selectedAnnotation: MKAnnotation? = nil
//    var selectedPin: MKPlacemark? = nil
//    private let locationManager = CLLocationManager()
    private let rangeInMeters: Double = 1000000
    //var currentLocation: CLLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let earthquakeDetail = earthquakeDetail {
            configure(with: earthquakeDetail)
        }
    }

    func didTapButton() {
        navigationController?.popViewController(animated: true) // Volver si es por navegacion
        //dismiss(animated: true) // Si es modal
    }
    
    private func configure(with earthquakeDetail: EarthquakeDetail) {
        // Formatting Date
        let myDateFormatter = MyDateFormatter()
        let formattedDate = myDateFormatter.formatDate(dateToFormat: earthquakeDetail.time)
        
        // Assigning data to variables
        let titleSplit = earthquakeDetail.title.components(separatedBy: " of ")
        titleLabel.text = titleSplit.last
        placeLabel.attributedText = getLabelText(labelTitle: "Place:  ", labelContent: (earthquakeDetail.place ?? "Unknown"))
        timeLabel.attributedText = getLabelText(labelTitle: "Time:  ", labelContent: "\(formattedDate)")
        tsunamiLabel.attributedText = getLabelText(labelTitle: "Tsunami:  ", labelContent: "\(earthquakeDetail.tsunami)")
        coordsLabel.attributedText = getLabelText(labelTitle: "Coords:  ", labelContent: "\(earthquakeDetail.coords)")
        
        if let magnitude = earthquakeDetail.magnitude {
            magnitudeLabel.attributedText = getLabelText(labelTitle: "Magnitude:  ", labelContent: "\(magnitude)")
        } else {
            magnitudeLabel.attributedText = getLabelText(labelTitle: "Magnitude:  ", labelContent: "Magnitude unknown")
        }
        
        // MapView config
        mapView.delegate = self
        
        //TODO: cambiar por latitud ...
        let longitude = earthquakeDetail.coords[0]
        let latitude = earthquakeDetail.coords[1]
        let location = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
        
        let coordinateRegion = MKCoordinateRegion.init(
            center: location,
            latitudinalMeters: rangeInMeters,
            longitudinalMeters: rangeInMeters)
        mapView.setRegion(coordinateRegion, animated: false)
        
        //TODO: Castear CLLocationCoordinate2D' a 'CLLocation'
        //let selectedLocation: CLLocation =  CLLocation(latitude: CLLocationDegrees(coord2), longitude: CLLocationDegrees(coord1))
        
        //TODO: Crear placemark a partir de location
        /*let geocoder = CLGeocoder()
        var placemark: CLPlacemark!
        geocoder.reverseGeocodeLocation(selectedLocation, completionHandler: { (placemarks, error) -> Void in
            // Place details
            placemark = placemarks?[0]
        })*/
        
        
//        geocode(latitude: Double(coord2), longitude: Double(coord1)) { placemark, error in
//            guard let placemark = placemark, error == nil else { return }
//            print(placemark)
//            //self.dropPinZoomIn(placemark: placemark as! MKPlacemark)
//            //self.mapView.addAnnotation(placemark)
//        }
        
        let coords = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
        let annotation = MKPointAnnotation()
        annotation.coordinate = coords
        if let substring = earthquakeDetail.place?.split(separator: ",").last {
            annotation.title = String(substring)
        }
        mapView.addAnnotation(annotation)
        
        /*mapView.annotations
            .compactMap { $0 as? MKPointAnnotation }
            .forEach { existingMarker in
                existingMarker.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(coord2), longitude: CLLocationDegrees(coord1))
                mapView.addAnnotation(existingMarker)
        }*/
        
        /*MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = location;
        [_mapView addAnnotation: annotation];*/
                    
        // TODO: Hace falta???
        //mapView.addAnnotation(selectedAnnotation!)
        
        //let geocoder = CLGeocoder()
        //geocoder.reverseGeocodeLocation(_:completionHandler:)
        //dropPinZoomIn(placemark: <#T##MKPlacemark#>)
        //selectedPin = matchingItems[indexPath.row].placemark
        //handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        //mapView.addAnnotations(selectedAnnotation as! [MKAnnotation])
    }
    
//    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
//        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
//    }
    
    private func getLabelText(labelTitle: String, labelContent: String) -> NSMutableAttributedString {
        let boldText = labelTitle
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 21)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

        let normalText = labelContent
        let normalString = NSMutableAttributedString(string:normalText)

        attributedString.append(normalString)
        return attributedString
    }
    
    /*func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
                    -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
                
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                        completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    completionHandler(firstLocation)
                }
                else {
                 // An error occurred during geocoding.
                    completionHandler(nil)
                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }*/
}

extension EarthquakeDetailViewController {
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
        view.canShowCallout = false
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        //view.markerTintColor = annotation.markerTintColor // Change color of pins in map
        return view
    }
    
//    func dropPinZoomIn(placemark: MKPlacemark){
//        //selectedPin = placemark
//        let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
//        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
//        mapView.setRegion(region, animated: true)
//
//    }
}
