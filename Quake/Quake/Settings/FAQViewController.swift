
import Foundation
import UIKit

class FAQViewController: UIViewController {
    
    @IBOutlet weak var faqCard: UIView!
    @IBOutlet weak var faqInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        faqCard.layer.shadowColor = UIColor.black.cgColor
        faqCard.layer.shadowOffset = CGSize(width: 1, height: 1)
        faqCard.layer.shadowRadius = 3
        faqCard.layer.shadowOpacity = 0.2
        
        faqInfoLabel.text = "Why there are earthquakes with negative magnitudes?"
    }
    
    //TODO: Añadir info sobre magnitudes negativas, profundidad de los terremotos, etc.
}
