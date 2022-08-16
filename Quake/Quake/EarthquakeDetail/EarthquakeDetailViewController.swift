
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

    var getFormattedCoordsUseCase = GetFormattedCoordsUseCase()
    let getTsunamiValueUseCase = GetTsunamiValueUseCase()

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
    
    func updateView(with detail: EarthquakeDetail) {
        configure(with: detail)
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
        placeLabel.attributedText = getLabelText(labelTitle: "Place:  ", labelContent: (earthquakeDetail.place ?? "Unknown"))
        timeLabel.attributedText = getLabelText(labelTitle: "Time:  ", labelContent: "\(formattedDate)")
        
        let tsunamiValue = getTsunamiValueUseCase.getTsunamiValue(tsunami: earthquakeDetail.tsunami )
        tsunamiLabel.attributedText = getLabelText(labelTitle: "Tsunami:  ", labelContent: "\(tsunamiValue)")
        
        let formattedCoords = getFormattedCoordsUseCase.getFormattedCoords(actualCoords: earthquakeDetail.coords)
        coordsLabel.attributedText = getLabelText(labelTitle: "Coords:  ", labelContent: "\(formattedCoords)")
        
        if let depth = earthquakeDetail.coords[2] as Float? {
            depthLabel.attributedText = getLabelText(labelTitle: "Depth: ", labelContent: "\(depth)km")
        }
        
        if let magnitude = earthquakeDetail.magnitude {
            let magnitudeColor = viewModel.assignMagnitudeColor(magnitude: magnitude)
            magnitudeLabel.attributedText = getLabelText(labelTitle: "Magnitude:  ", labelContent: "\(magnitude)", contentColor: magnitudeColor)
        } else {
            magnitudeLabel.attributedText = getLabelText(labelTitle: "Magnitude:  ", labelContent: " Unknown")
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
