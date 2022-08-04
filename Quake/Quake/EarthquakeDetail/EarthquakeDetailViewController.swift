
import UIKit
import MapKit

class EarthquakeDetailViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tsunamiLabel: UILabel!
    @IBOutlet weak var coordsLabel: UILabel!
    @IBOutlet weak var magnitudeLabel: UILabel!
    
    let viewModel = EarthquakeDetailViewModel()
    var earthquakeDetail: EarthquakeDetail?
    
    // MapView
    @IBOutlet weak var mapView: MKMapView!
    private let rangeInMeters: Double = 1000000
    
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
            let magnitudeColor = viewModel.assignMagnitudeColor(magnitude: magnitude)
            magnitudeLabel.attributedText = getLabelText(labelTitle: "Magnitude:  ", labelContent: "\(magnitude)", contentColor: magnitudeColor)
        } else {
            magnitudeLabel.attributedText = getLabelText(labelTitle: "Magnitude:  ", labelContent: "Magnitude unknown")
        }
        
        // MapView config
        mapView.delegate = self
        
        let longitude = earthquakeDetail.coords[0]
        let latitude = earthquakeDetail.coords[1]
        let location = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
        
        let coordinateRegion = MKCoordinateRegion.init(
            center: location,
            latitudinalMeters: rangeInMeters,
            longitudinalMeters: rangeInMeters)
        mapView.setRegion(coordinateRegion, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        if let substring = earthquakeDetail.place?.split(separator: ",").last {
            annotation.title = String(substring)
        }
        mapView.addAnnotation(annotation)
    }
    
    private func getLabelText(labelTitle: String, labelContent: String, contentColor: UIColor = .black) -> NSMutableAttributedString {
        let titleAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 21)]
        let titleString = NSMutableAttributedString(string: labelTitle, attributes: titleAttributes)

        let contentAttributes = [NSAttributedString.Key.foregroundColor : contentColor]
        let contentString = NSMutableAttributedString(string: labelContent, attributes: contentAttributes)

        titleString.append(contentString)
        return titleString
    }
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
        view.markerTintColor = annotation.markerTintColor // Change color of pins in map
        return view
    }
}
