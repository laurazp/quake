
import UIKit

class EarthquakeDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tsunamiLabel: UILabel!
    @IBOutlet weak var coordsLabel: UILabel!
    @IBOutlet weak var magnitudeLabel: UILabel!
    
    var earthquakeDetail: EarthquakeDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor.systemMint
        
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium //TODO: mirar formato !!!
        let formattedDate = dateFormatter.string(from: earthquakeDetail.time)
        
        // Assigning data to variables
        titleLabel.text = earthquakeDetail.title
        placeLabel.text = "Place: \(earthquakeDetail.place ?? "Unknown")"
        timeLabel.text = "Time: \(formattedDate)"
        tsunamiLabel.text = "Tsunami: \(earthquakeDetail.tsunami)"
        coordsLabel.text = "Coords: \(earthquakeDetail.coords)"
        magnitudeLabel.text = "Magnitude: \(earthquakeDetail.magnitude)"
    }
}
