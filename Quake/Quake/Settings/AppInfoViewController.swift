
import UIKit

class AppInfoViewController: UIViewController {
    
    @IBOutlet weak var apiCard: UIView!
    @IBOutlet weak var apiInfoTitleLabel: UILabel!
    @IBOutlet weak var apiInfoContentLabel: UILabel!
    @IBOutlet weak var creditsTitleLabel: UILabel!
    @IBOutlet weak var creditsContentLabel: UILabel!
    @IBOutlet weak var credits2ContentLabel: UILabel!
    @IBOutlet weak var credits3ContentLabel: UILabel!
    @IBOutlet weak var credits4ContentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
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
        
        apiInfoTextArray.append("Data source credits belongs to")
        apiInfoTextArray.append("USGS (United States Geological Survey)\n")
        
        apiInfoFontArray.append(.systemFont(ofSize: 17))
        apiInfoFontArray.append(.systemFont(ofSize: 17, weight: .semibold))
        
        apiInfoColorArray.append(UIColor.label)
        apiInfoColorArray.append(.systemBlue)
        
        apiInfoContentLabel.attributedText = getAttributedString(arrayText: apiInfoTextArray, arrayColors: apiInfoColorArray, arrayFonts: apiInfoFontArray)
        
        //Credits
        creditsTitleLabel.text = "\nCredits"
        
        var creditsTextArray = [String]()
        var creditsFontArray = [UIFont]()
        var creditsColorArray = [UIColor]()
        
        creditsTextArray.append("Seismic icons created by")
        creditsTextArray.append("Freepik - Flaticon\n")
        
        creditsFontArray.append(.systemFont(ofSize: 17))
        creditsFontArray.append(.systemFont(ofSize: 17, weight: .semibold))
        
        creditsColorArray.append(UIColor.label)
        creditsColorArray.append(.systemBlue)
        
        creditsContentLabel.attributedText = getAttributedString(arrayText: creditsTextArray, arrayColors: creditsColorArray, arrayFonts: creditsFontArray)
        
        //Credits2
        var credits2TextArray = [String]()
        var credits2FontArray = [UIFont]()
        var credits2ColorArray = [UIColor]()
        
        credits2TextArray.append("Earthquake icons created by")
        credits2TextArray.append("fjstudio - Flaticon\n")
        
        credits2FontArray.append(.systemFont(ofSize: 17))
        credits2FontArray.append(.systemFont(ofSize: 17, weight: .semibold))
        
        credits2ColorArray.append(UIColor.label)
        credits2ColorArray.append(.systemBlue)
        
        credits2ContentLabel.attributedText = getAttributedString(arrayText: credits2TextArray, arrayColors: credits2ColorArray, arrayFonts: credits2FontArray)
        
        //Credits3
        var credits3TextArray = [String]()
        var credits3FontArray = [UIFont]()
        var credits3ColorArray = [UIColor]()
        
        credits3TextArray.append("DetectLinksUILabel code from")
        credits3TextArray.append("leoiphonedev - Github\n")
        
        credits3FontArray.append(.systemFont(ofSize: 17))
        credits3FontArray.append(.systemFont(ofSize: 17, weight: .semibold))
        
        credits3ColorArray.append(UIColor.label)
        credits3ColorArray.append(.systemBlue)
        
        credits3ContentLabel.attributedText = getAttributedString(arrayText: credits3TextArray, arrayColors: credits3ColorArray, arrayFonts: credits3FontArray)
        
        //Credits4
        var credits4TextArray = [String]()
        var credits4FontArray = [UIFont]()
        var credits4ColorArray = [UIColor]()
        
        credits4TextArray.append("CTFeedbackSwift Package code from")
        credits4TextArray.append("rizumita - Github\n")
        
        credits4FontArray.append(.systemFont(ofSize: 17))
        credits4FontArray.append(.systemFont(ofSize: 17, weight: .semibold))
        
        credits4ColorArray.append(UIColor.label)
        credits4ColorArray.append(.systemBlue)
        
        credits4ContentLabel.attributedText = getAttributedString(arrayText: credits4TextArray, arrayColors: credits4ColorArray, arrayFonts: credits4FontArray)
        
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
        
        // Configure credits4ContentLabel for TapGesture
        self.credits4ContentLabel.isUserInteractionEnabled = true
        let credits4Tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        credits4Tapgesture.numberOfTapsRequired = 1
        self.credits4ContentLabel.addGestureRecognizer(credits4Tapgesture)
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
        
        guard let credits4Text = self.credits4ContentLabel.text else { return }
        let credits4LinkRange = (credits4Text as NSString).range(of: "rizumita - Github")
        
        if gesture.didTapAttributedTextInLabel(label: self.apiInfoContentLabel, inRange: apiLinkRange) {
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
            
        } else if gesture.didTapAttributedTextInLabel(label: self.credits4ContentLabel, inRange: credits4LinkRange) {
            guard let url = URL(string: "https://github.com/rizumita/CTFeedbackSwift") else {
                return
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
