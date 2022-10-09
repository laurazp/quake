
import UIKit

class UnitsViewController: UIViewController {

    @IBOutlet weak var unitsCard: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func setupViews() {
        unitsCard.layer.shadowColor = UIColor.black.cgColor
        unitsCard.layer.shadowOffset = CGSize(width: 1, height: 1)
        unitsCard.layer.shadowRadius = 3
        unitsCard.layer.shadowOpacity = 0.2
        
       
    }
    
}
