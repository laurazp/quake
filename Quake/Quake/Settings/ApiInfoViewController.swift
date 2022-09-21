
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
        
        //Add link to apiInfoContentLabel
        var apiInfoTextArray = [String]()
        var apiInfoFontArray = [UIFont]()
        var apiInfoColorArray = [UIColor]()
        
        apiInfoTextArray.append("Data source credit belongs to")
        apiInfoTextArray.append("USGS (United States Geological Survey)")
        //apiInfoTextArray.append("(United States Geological Survey)")
        
        apiInfoFontArray.append(.systemFont(ofSize: 17))
        apiInfoFontArray.append(.systemFont(ofSize: 17, weight: .semibold))
        //apiInfoFontArray.append(.systemFont(ofSize: 17))
        
        apiInfoColorArray.append(.black)
        apiInfoColorArray.append(.systemBlue)
        //apiInfoColorArray.append(.black)

        apiInfoContentLabel.attributedText = getAttributedString(arrayText: apiInfoTextArray, arrayColors: apiInfoColorArray, arrayFonts: apiInfoFontArray)
        
        creditsTitleLabel.text = "\nCredits"
        
        //Add link to creditsContentLabel
        var creditsTextArray = [String]()
        var creditsFontArray = [UIFont]()
        var creditsColorArray = [UIColor]()
        
        creditsTextArray.append("Seismic icons created by")
        creditsTextArray.append("Freepik - Flaticon")
        
        creditsFontArray.append(.systemFont(ofSize: 17))
        creditsFontArray.append(.systemFont(ofSize: 17, weight: .semibold))
        
        creditsColorArray.append(.black)
        creditsColorArray.append(.systemBlue)

        creditsContentLabel.attributedText = getAttributedString(arrayText: creditsTextArray, arrayColors: creditsColorArray, arrayFonts: creditsFontArray)
                
        developerTitleLabel.text = " \nSupport"
        
        //Add link to developerContentLabel
        var developerTextArray = [String]()
        var developerFontArray = [UIFont]()
        var developerColorArray = [UIColor]()
        
        developerTextArray.append("If you have any questions, please feel free to contact us at")
        developerTextArray.append("quake@gmail.com")
        
        developerFontArray.append(.systemFont(ofSize: 17))
        developerFontArray.append(.systemFont(ofSize: 17, weight: .semibold))
        
        developerColorArray.append(.black)
        developerColorArray.append(.systemBlue)

        developerContentLabel.attributedText = getAttributedString(arrayText: developerTextArray, arrayColors: developerColorArray, arrayFonts: developerFontArray)
        
        // Configure apiInfoContentLabel for TapGesture
        self.apiInfoContentLabel.isUserInteractionEnabled = true
        let apiTapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        apiTapgesture.numberOfTapsRequired = 1
        self.apiInfoContentLabel.addGestureRecognizer(apiTapgesture)
        
        // Configure creditsContentLabel for TapGesture
        self.creditsContentLabel.isUserInteractionEnabled = true
        let creditsTapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        creditsTapgesture.numberOfTapsRequired = 1
        self.creditsContentLabel.addGestureRecognizer(creditsTapgesture)
        
        // Configure developerContentLabel for TapGesture
        self.developerContentLabel.isUserInteractionEnabled = true
        let developerTapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        developerTapgesture.numberOfTapsRequired = 1
        self.developerContentLabel.addGestureRecognizer(developerTapgesture)
    }
    
    //MARK:- getAttributedString
    func getAttributedString(arrayText:[String]?, arrayColors:[UIColor]?, arrayFonts:[UIFont]?) -> NSMutableAttributedString {
        
        let finalAttributedString = NSMutableAttributedString()
        
        for i in 0 ..< (arrayText?.count)! {
            
            let attributes = [NSAttributedString.Key.foregroundColor: arrayColors?[i], NSAttributedString.Key.font: arrayFonts?[i]]
            let attributedStr = (NSAttributedString.init(string: arrayText?[i] ?? "", attributes: attributes as [NSAttributedString.Key : Any]))
            
            if i != 0 {
                
                finalAttributedString.append(NSAttributedString.init(string: " "))
            }
            
            finalAttributedString.append(attributedStr)
        }
        
        return finalAttributedString
    }
    
    //MARK:- tappedOnLabel
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let apiText = self.apiInfoContentLabel.text else { return }
        let apiLinkRange = (apiText as NSString).range(of: "USGS (United States Geological Survey)")
        
        guard let creditsText = self.creditsContentLabel.text else { return }
        let creditsLinkRange = (creditsText as NSString).range(of: "Freepik - Flaticon")
        
        guard let developerText = self.developerContentLabel.text else { return }
        let developerLinkRange = (developerText as NSString).range(of: "quake@gmail.com")
        
        if gesture.didTapAttributedTextInLabel(label: self.apiInfoContentLabel, inRange: apiLinkRange) {
            //Open API web page
            guard let url = URL(string: "https://earthquake.usgs.gov/fdsnws/event/1/") else {
              return //be safe
            }

            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
//            let alertcontroller = UIAlertController(title: "Tapped on", message: "user tapped on api link text", preferredStyle: .alert)
//            let alertAction = UIAlertAction(title: "OK", style: .default) { (alert) in
//
//            }
//            alertcontroller.addAction(alertAction)
//            self.present(alertcontroller, animated: true)
        } else if gesture.didTapAttributedTextInLabel(label: self.creditsContentLabel, inRange: creditsLinkRange) {
            //Open web page
            guard let url = URL(string: "https://www.flaticon.com/free-icons/seismic") else {
              return //be safe
            }

            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
            
            //https://github.com/leoiphonedev/DetectLinksUILabel --> link for Credits
            
            
        } else if gesture.didTapAttributedTextInLabel(label: self.developerContentLabel, inRange: developerLinkRange) {
            //TODO: link to mail app
            let email = "quake@gmail.com"
            guard let url = URL(string: "mailto:\(email)") else {
              return //be safe
            }

            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
