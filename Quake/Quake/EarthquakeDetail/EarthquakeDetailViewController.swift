
import UIKit
import MapKit

class EarthquakeDetailViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tsunamiLabel: UILabel!
    @IBOutlet weak var coordsLabel: UILabel!
    @IBOutlet weak var magnitudeLabel: UILabel!
    @IBOutlet weak var depthLabel: UILabel!
    
    let viewModel = EarthquakeDetailViewModel()

    var getFormattedCoordsFormatter = GetFormattedCoordsFormatter()
    let getTsunamiValueFormatter = GetTsunamiValueFormatter()

    @IBOutlet weak var infoCard: UIView!
    @IBOutlet weak var mapCard: UIView!
    
    // MapView
    @IBOutlet weak var mapView: MKMapView!
    private let rangeInMeters: Double = 1000000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func setupViews() {
        infoCard.layer.shadowColor = UIColor.black.cgColor
        infoCard.layer.shadowOffset = CGSize(width: 1, height: 1)
        infoCard.layer.shadowRadius = 3
        infoCard.layer.shadowOpacity = 0.2
        
        mapCard.layer.shadowColor = UIColor.black.cgColor
        mapCard.layer.shadowOffset = CGSize(width: 1, height: 1)
        mapCard.layer.shadowRadius = 3
        mapCard.layer.shadowOpacity = 0.2
    }
    
    func updateView(with model: EarthquakeModel) {
        configure(with: model)
    }

    func didTapButton() {
        navigationController?.popViewController(animated: true) // Turn back
    }
    
    private func configure(with earthquakeModel: EarthquakeModel) {
        placeLabel.attributedText = getLabelText(labelTitle: "Place:  ", labelContent: earthquakeModel.place)
        timeLabel.attributedText = getLabelText(labelTitle: "Time:  ", labelContent: earthquakeModel.date)
        tsunamiLabel.attributedText = getLabelText(labelTitle: "Tsunami:  ", labelContent: earthquakeModel.tsunami)
        coordsLabel.attributedText = getLabelText(labelTitle: "Coords:  ", labelContent: earthquakeModel.date)
        depthLabel.attributedText = getLabelText(labelTitle: "Depth: ", labelContent: earthquakeModel.depth)
        
        let magnitudeColor = viewModel.assignMagnitudeColor(magnitude: Double(earthquakeModel.magnitude) ?? 0)
        magnitudeLabel.attributedText = getLabelText(labelTitle: "Magnitude:  ", labelContent: earthquakeModel.magnitude, contentColor: magnitudeColor)
        
        // MapView config
        mapView.delegate = self
        
        let longitude = earthquakeModel.originalCoords[0]
        let latitude = earthquakeModel.originalCoords[1]
        let location = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
        
        let coordinateRegion = MKCoordinateRegion.init(
            center: location,
            latitudinalMeters: rangeInMeters,
            longitudinalMeters: rangeInMeters)
        mapView.setRegion(coordinateRegion, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = earthquakeModel.simplifiedTitle

        mapView.addAnnotation(annotation)
    }
    
    private func getLabelText(labelTitle: String, labelContent: String, contentColor: UIColor = .label) -> NSMutableAttributedString {
        let titleAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)]
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
