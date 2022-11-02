
import UIKit

class ApiInfoViewController: UIViewController {

    @IBOutlet weak var apiCard: UIView!
    @IBOutlet weak var apiInfoTitleLabel: UILabel!
    @IBOutlet weak var apiInfoContentLabel: UILabel!
    @IBOutlet weak var creditsTitleLabel: UILabel!
    @IBOutlet weak var creditsContentLabel: UILabel!
    @IBOutlet weak var developerTitleLabel: UILabel!
    @IBOutlet weak var developerContentLabel: UILabel!    
    @IBOutlet weak var credits2ContentLabel: UILabel!
    @IBOutlet weak var credits3ContentLabel: UILabel!
    
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
        //API Info
        apiInfoTitleLabel.text = "API Info"
        
        var apiInfoTextArray = [String]()
        var apiInfoFontArray = [UIFont]()
        var apiInfoColorArray = [UIColor]()
        
        apiInfoTextArray.append("Data source credit belongs to")
        apiInfoTextArray.append("USGS (United States Geological Survey)")
        
        apiInfoFontArray.append(.systemFont(ofSize: 17, weight: .semibold))
        apiInfoFontArray.append(.systemFont(ofSize: 17, weight: .semibold))
        
        apiInfoColorArray.append(.systemGray)
        apiInfoColorArray.append(.systemBlue)

        apiInfoContentLabel.attributedText = getAttributedString(arrayText: apiInfoTextArray, arrayColors: apiInfoColorArray, arrayFonts: apiInfoFontArray)
        
        //Credits
        creditsTitleLabel.text = "\nCredits"
        
        var creditsTextArray = [String]()
        var creditsFontArray = [UIFont]()
        var creditsColorArray = [UIColor]()
        
        creditsTextArray.append("Seismic icons created by")
        creditsTextArray.append("Freepik - Flaticon\n")
        
        creditsFontArray.append(.systemFont(ofSize: 17, weight: .semibold))
        creditsFontArray.append(.systemFont(ofSize: 17, weight: .semibold))
        
        creditsColorArray.append(.systemGray)
        creditsColorArray.append(.systemBlue)

        creditsContentLabel.attributedText = getAttributedString(arrayText: creditsTextArray, arrayColors: creditsColorArray, arrayFonts: creditsFontArray)
        
        //Credits2
        var credits2TextArray = [String]()
        var credits2FontArray = [UIFont]()
        var credits2ColorArray = [UIColor]()
        
        credits2TextArray.append("Earthquake icons created by")
        credits2TextArray.append("fjstudio - Flaticon\n")
        
        credits2FontArray.append(.systemFont(ofSize: 17, weight: .semibold))
        credits2FontArray.append(.systemFont(ofSize: 17, weight: .semibold))
        
        credits2ColorArray.append(.systemGray)
        credits2ColorArray.append(.systemBlue)

        credits2ContentLabel.attributedText = getAttributedString(arrayText: credits2TextArray, arrayColors: credits2ColorArray, arrayFonts: credits2FontArray)
        
        //Credits3
        var credits3TextArray = [String]()
        var credits3FontArray = [UIFont]()
        var credits3ColorArray = [UIColor]()
        
        credits3TextArray.append("API info links code from")
        credits3TextArray.append("leoiphonedev - Github\n")
        
        credits3FontArray.append(.systemFont(ofSize: 17, weight: .semibold))
        credits3FontArray.append(.systemFont(ofSize: 17, weight: .semibold))
        
        credits3ColorArray.append(.systemGray)
        credits3ColorArray.append(.systemBlue)

        credits3ContentLabel.attributedText = getAttributedString(arrayText: credits3TextArray, arrayColors: credits3ColorArray, arrayFonts: credits3FontArray)
        
        //Support
        developerTitleLabel.text = " \nSupport"
        
        var developerTextArray = [String]()
        var developerFontArray = [UIFont]()
        var developerColorArray = [UIColor]()
        
        developerTextArray.append("If you have any questions, please feel free to contact us at")
        developerTextArray.append("quake@gmail.com")
        
        developerFontArray.append(.systemFont(ofSize: 17, weight: .semibold))
        developerFontArray.append(.systemFont(ofSize: 17, weight: .semibold))
        
        developerColorArray.append(.systemGray)
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
        
        // Configure credits2ContentLabel for TapGesture
        self.credits2ContentLabel.isUserInteractionEnabled = true
        let credits2Tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        credits2Tapgesture.numberOfTapsRequired = 1
        self.credits2ContentLabel.addGestureRecognizer(credits2Tapgesture)
        
        // Configure credits3ContentLabel for TapGesture
        self.credits3ContentLabel.isUserInteractionEnabled = true
        let credits3Tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        credits3Tapgesture.numberOfTapsRequired = 1
        self.credits3ContentLabel.addGestureRecognizer(credits3Tapgesture)
        
        // Configure developerContentLabel for TapGesture
        self.developerContentLabel.isUserInteractionEnabled = true
        let developerTapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        developerTapgesture.numberOfTapsRequired = 1
        self.developerContentLabel.addGestureRecognizer(developerTapgesture)
    }
    
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
    
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let apiText = self.apiInfoContentLabel.text else { return }
        let apiLinkRange = (apiText as NSString).range(of: "USGS (United States Geological Survey)")
        
        guard let creditsText = self.creditsContentLabel.text else { return }
        let creditsLinkRange = (creditsText as NSString).range(of: "Freepik - Flaticon")
        
        guard let credits2Text = self.credits2ContentLabel.text else { return }
        let credits2LinkRange = (credits2Text as NSString).range(of: "fjstudio - Flaticon")
        
        guard let credits3Text = self.credits3ContentLabel.text else { return }
        let credits3LinkRange = (credits3Text as NSString).range(of: "leoiphonedev - Github")
        
        guard let developerText = self.developerContentLabel.text else { return }
        let developerLinkRange = (developerText as NSString).range(of: "quake@gmail.com")
        
        if gesture.didTapAttributedTextInLabel(label: self.apiInfoContentLabel, inRange: apiLinkRange) {
            //Open API web page
            guard let url = URL(string: "https://earthquake.usgs.gov/fdsnws/event/1/") else {
              return
            }

            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else if gesture.didTapAttributedTextInLabel(label: self.creditsContentLabel, inRange: creditsLinkRange) {
            guard let url = URL(string: "https://www.flaticon.com/free-icons/seismic") else {
              return
            }

            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        } else if gesture.didTapAttributedTextInLabel(label: self.credits2ContentLabel, inRange: credits2LinkRange) {
            guard let url = URL(string: "https://www.flaticon.com/free-icons/earthquake") else {
              return
            }

            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        } else if gesture.didTapAttributedTextInLabel(label: self.credits3ContentLabel, inRange: credits3LinkRange) {
            guard let url = URL(string: "https://github.com/leoiphonedev/DetectLinksUILabel") else {
              return
            }

            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        } else if gesture.didTapAttributedTextInLabel(label: self.developerContentLabel, inRange: developerLinkRange) {
            // Show alert before sending an e-mail
            let alertcontroller = UIAlertController(title: "Alert", message: "Are you sure you want to open your e-mail app?", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default) { (alert) in
                //Link to mail app
                let email = "quake@gmail.com"
                guard let url = URL(string: "mailto:\(email)") else {
                  return
                }
                
                if let url = URL(string: "mailto:\(email)") {
                    if(UIApplication.shared.canOpenURL(url)){
                        print("ok")
                    } else {
                        print("not ok")
                    }
                }

                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            alertcontroller.addAction(alertAction)
            self.present(alertcontroller, animated: true)
        }
    }
}


// Reference from https://stackoverflow.com/questions/40878547/is-it-possible-to-have-uidatepicker-work-with-start-and-end-time
