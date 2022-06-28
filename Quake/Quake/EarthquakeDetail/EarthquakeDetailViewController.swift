
import UIKit

class EarthquakeDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var tsunamiLabel: UILabel!
    @IBOutlet weak var coordsLabel: UILabel!
    @IBOutlet weak var magnitudeLabel: UILabel!
    
    var earthquakeDetail: EarthquakeDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .orange
       
        if let earthquakeDetail = earthquakeDetail {
            configure(with: earthquakeDetail)
        }
    }

    func didTapButton() {
        navigationController?.popViewController(animated: true) // Volver si es por navegacion
        //dismiss(animated: true) // Si es modal
    }
    
    private func configure(with earthquakeDetail: EarthquakeDetail) {
        titleLabel.text = earthquakeDetail.title
        placeLabel.text = "Place: \(earthquakeDetail.place)"
        tsunamiLabel.text = "Tsunami: \(earthquakeDetail.tsunami)"
        coordsLabel.text = "Coords: \(earthquakeDetail.coords)"
        magnitudeLabel.text = "Magnitude: \(earthquakeDetail.magnitude)"
    }
}



/*
 struct Feature: Codable {
     let properties: Property
     let geometry: Geometry
 }
         
 struct Property: Codable {
     let mag: Double
     let place: String
     //let time: Date
     let tsunami: Int
     let title: String
 }
         
 struct Geometry: Codable {
     let coordinates: [Float]
 }
 */
