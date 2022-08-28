
import Foundation
import UIKit

class FAQViewController: UIViewController {
    
    @IBOutlet weak var faqCard: UIView!
    @IBOutlet weak var firstQuestionLabel: UILabel!
    @IBOutlet weak var firstAnswerLabel: UILabel!
    @IBOutlet weak var secondQuestionLabel: UILabel!
    @IBOutlet weak var secondAnswerLabel: UILabel!
    
    //TODO: Añadir info sobre magnitudes negativas, profundidad de los terremotos... AQUÍ????!!!
    private let firstQuestion = "Why there are earthquakes with negative magnitudes? \n"
    private let firstAnswer = "A negative magnitude means an earthquake that is not felt by humans because it's smaller than those originally chosen for zero magnitude in the Richter scale. That's possible because modern seismographs can detect smaller seismic waves than before. \n\n"
    private let secondQuestion = "What's the depth of an earthquake? \n"
    private let secondAnswer = "It's the distance in kilometers at which the earthquake occurred. If we have a depth of 0km or a negative depth, it's because the earthquake was too shallow and it's so difficult to determine its exact depth (it's possible to have an error of 1-2km when determining the actual depth of an earthquake). \n"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        faqCard.layer.shadowColor = UIColor.black.cgColor
        faqCard.layer.shadowOffset = CGSize(width: 1, height: 1)
        faqCard.layer.shadowRadius = 3
        faqCard.layer.shadowOpacity = 0.2
        
        firstQuestionLabel.text = firstQuestion
        firstAnswerLabel.text = firstAnswer
        secondQuestionLabel.text = secondQuestion
        secondAnswerLabel.text = secondAnswer
    }
}
