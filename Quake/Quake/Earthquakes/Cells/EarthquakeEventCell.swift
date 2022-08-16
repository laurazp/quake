
import UIKit

protocol EarthquakeEventCellDelegate: AnyObject {
    func didExpandCell(isExpanded: Bool, indexPath: IndexPath)
}

class EarthquakeEventCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var magLabel: UILabel!
    @IBOutlet weak var expandableView: UIView!
    @IBOutlet weak var expandableButton: UIButton!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tsunamiLabel: UILabel!
    @IBOutlet weak var coordsLabel: UILabel!
    @IBOutlet weak var depthLabel: UILabel!
    
    var earthquakeViewController: EarthquakeViewController = EarthquakeViewController()
    
    var indexPath: IndexPath = IndexPath()
    weak var delegate: EarthquakeEventCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        expandableView.isHidden = true //Expandable view is hidden by default
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        magLabel.text = nil
        placeLabel.text = nil
        timeLabel.text = nil
        tsunamiLabel.text = nil
        coordsLabel.text = nil
        depthLabel.text = nil
        
        expandableView.isHidden = true
        expandableView.alpha = 0
        expandableButton.transform = CGAffineTransform.identity
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func animate(duration:Double, c: @escaping () -> Void) {
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModePaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration, animations: {
                
                self.expandableView.isHidden.toggle()
                if self.expandableView.alpha == 1 {
                    self.expandableView.alpha = 0.7
                } else {
                    self.expandableView.alpha = 1
                }
                // Rotate chevron 180 degrees so it looks upwards
                self.expandableButton.transform = self.expandableButton.transform.rotated(by: .pi)
            })
        }, completion: {  (finished: Bool) in
            c()
        })
    }
    
    @IBAction func buttonPressedDown(_ sender: Any) {
        delegate?.didExpandCell(isExpanded: !expandableView.isHidden, indexPath: indexPath)
    }
}
