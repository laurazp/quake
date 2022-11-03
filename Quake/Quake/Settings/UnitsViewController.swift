
import UIKit

class UnitsViewController: UIViewController {

    @IBOutlet weak var unitsCard: UIView!
    private let viewModel = EarthquakesViewModel()
    
    let segmentedControl: UISegmentedControl = {
       let segmentedControl = UISegmentedControl(items: ["Kilometers", "Miles"])
        segmentedControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return segmentedControl
    }()
    
    @objc func handleSegmentChange() {
        viewModel.setSelectedUnit(selectedIndex: segmentedControl.selectedSegmentIndex)
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
        
        segmentedControl.selectedSegmentIndex = getSelectedSegmentIndex()
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
    
    private func getSelectedSegmentIndex() -> Int {
        return viewModel.getSelectedUnit()
    }
}
