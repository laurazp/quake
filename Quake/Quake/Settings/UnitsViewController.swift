
import UIKit

class UnitsViewController: UIViewController {

    @IBOutlet weak var unitsCard: UIView!
    
    let segmentedControl: UISegmentedControl = {
       let segmentedControl = UISegmentedControl(items: ["Kilometers", "Miles"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return segmentedControl
    }()
    
    @objc fileprivate func handleSegmentChange() {
        if segmentedControl.selectedSegmentIndex == 0 {
            print("Kilometers selected")
            //TODO: Cambiar units a km
        } else {
            print("Miles selected")
            //TODO: Cambiar units a miles

        }
    }
    
    let lengthLabel: UILabel = {
        let label = UILabel()
        label.text = "Length"
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        unitsCard.layer.shadowColor = UIColor.black.cgColor
        unitsCard.layer.shadowOffset = CGSize(width: 1, height: 1)
        unitsCard.layer.shadowRadius = 3
        unitsCard.layer.shadowOpacity = 0.2
        
        setupStackView()
    }
    
    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [
            lengthLabel, segmentedControl
        ])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        unitsCard.addSubview(stackView)

        let margins = view.layoutMarginsGuide
        stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20).isActive = true
        stackView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 30).isActive = true
        stackView.setCustomSpacing(10, after: lengthLabel)
    }
}
