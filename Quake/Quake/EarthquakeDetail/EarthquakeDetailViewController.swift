
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
        placeLabel.attributedText = getLabelText(labelTitle: "Place:  ", labelContent: (earthquakeDetail.place ?? "Unknown"))
        timeLabel.attributedText = getLabelText(labelTitle: "Time:  ", labelContent: "\(formattedDate)")
        tsunamiLabel.attributedText = getLabelText(labelTitle: "Tsunami:  ", labelContent: "\(earthquakeDetail.tsunami)")
        coordsLabel.attributedText = getLabelText(labelTitle: "Coords:  ", labelContent: "\(earthquakeDetail.coords)")
        magnitudeLabel.attributedText = getLabelText(labelTitle: "Magnitude:  ", labelContent: "\(earthquakeDetail.magnitude)")
        
        //placeLabel.text = "Place: \(earthquakeDetail.place ?? "Unknown")"
        //timeLabel.text = "Time: \(formattedDate)"
        //tsunamiLabel.text = "Tsunami: \(earthquakeDetail.tsunami)"
        //coordsLabel.text = "Coords: \(earthquakeDetail.coords)"
        //magnitudeLabel.text = "Magnitude: \(earthquakeDetail.magnitude)"
    }
    
    private func getLabelText(labelTitle: String, labelContent: String) -> NSMutableAttributedString {
        let boldText = labelTitle
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 21)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

        let normalText = labelContent
        let normalString = NSMutableAttributedString(string:normalText)

        attributedString.append(normalString)
        return attributedString
    }
}
