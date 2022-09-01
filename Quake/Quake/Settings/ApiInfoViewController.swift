
import UIKit

class ApiInfoViewController: UIViewController {

    @IBOutlet weak var apiCard: UIView!
    @IBOutlet weak var apiInfoTitleLabel: UILabel!
    @IBOutlet weak var apiInfoContentLabel: UILabel!
    @IBOutlet weak var creditsTitleLabel: UILabel!
    @IBOutlet weak var creditsContentLabel: UILabel!
    @IBOutlet weak var developerTitleLabel: UILabel!
    @IBOutlet weak var developerContentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLabels()
        setupViews()
    }
    
    private func setupViews() {
        apiCard.layer.shadowColor = UIColor.black.cgColor
        apiCard.layer.shadowOffset = CGSize(width: 1, height: 1)
        apiCard.layer.shadowRadius = 3
        apiCard.layer.shadowOpacity = 0.2
    }
    
    private func setupLabels() {
        apiInfoTitleLabel.text = "API Info"
        apiInfoContentLabel.text = ""
        creditsTitleLabel.text = "Credits"
        creditsContentLabel.text = ""
        developerTitleLabel.text = "Developer"
        developerContentLabel.text = ""
    }
}
