
import Foundation
import UIKit

struct GetMagnitudeColorUseCase {
    
    func getMagnitudeColor(magnitude: Double) -> UIColor {
        var magnitudeLevel: Int
        var magnitudeColor: UIColor
        
        if magnitude < 3 {
            magnitudeLevel = 1
        }
        else if magnitude >= 3 && magnitude < 5 {
            magnitudeLevel = 2
        }
        else {
            magnitudeLevel = 3
        }
        
        switch magnitudeLevel {
        case 1:
            magnitudeColor = .systemGreen
        case 2:
            magnitudeColor = .orange
        case 3:
            magnitudeColor = .red
        default:
            magnitudeColor = .blue
        }
        
        return magnitudeColor
    }
}
