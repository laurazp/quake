
import UIKit

protocol EarthquakeEventCellDelegate: AnyObject {
    func didExpandCell(isExpanded: Bool, indexPath: IndexPath)
}

class EarthquakeEventCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var magnitudeLabel: UILabel!
    @IBOutlet weak var expandableImage: UIImageView!
    @IBOutlet weak var expandableView: UIView!
    
    var indexPath: IndexPath = IndexPath()
    weak var delegate: EarthquakeEventCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(EarthquakeEventCell.tappedMe))
        expandableImage.addGestureRecognizer(tap)
        expandableImage.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func animate(duration:Double, c: @escaping () -> Void) {
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModePaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration, animations: {
                
                self.expandableView.isHidden = !self.expandableView.isHidden
                if self.expandableView.alpha == 1 {
                    self.expandableView.alpha = 0.5
                } else {
                    self.expandableView.alpha = 1
                }
            })
            
        }, completion: {  (finished: Bool) in
            print("animation complete")
            c()
        })
    }
    
    @objc private func tappedMe() {
        print("Tapped on ExpandableImage")
        
        delegate?.didExpandCell(isExpanded: !expandableView.isHidden, indexPath: indexPath)
    }
    
}
