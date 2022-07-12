
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
        let myDateFormatter = MyDateFormatter()
        let formattedDate = myDateFormatter.formatDate(dateToFormat: earthquakeDetail.time)
        
        // Assigning data to variables
        titleLabel.text = earthquakeDetail.title
        placeLabel.attributedText = getLabelText(labelTitle: "Place:  ", labelContent: (earthquakeDetail.place ?? "Unknown"))
        timeLabel.attributedText = getLabelText(labelTitle: "Time:  ", labelContent: "\(formattedDate)")
        tsunamiLabel.attributedText = getLabelText(labelTitle: "Tsunami:  ", labelContent: "\(earthquakeDetail.tsunami)")
        coordsLabel.attributedText = getLabelText(labelTitle: "Coords:  ", labelContent: "\(earthquakeDetail.coords)")
        
        if let magnitude = earthquakeDetail.magnitude {
            magnitudeLabel.attributedText = getLabelText(labelTitle: "Magnitude:  ", labelContent: "\(magnitude)")
        } else {
            magnitudeLabel.attributedText = getLabelText(labelTitle: "Magnitude:  ", labelContent: "Magnitude unknown")
        }
        
        
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
