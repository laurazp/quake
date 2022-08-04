
import Foundation
import UIKit

final class EarthquakeDetailViewModel {
    weak var viewDelegate: EarthquakeDetailViewController?
    
    private let getMagnitudeColorUseCase = GetMagnitudeColorUseCase()
    
    func assignMagnitudeColor(magnitude: Double) -> UIColor {
        return getMagnitudeColorUseCase.getMagnitudeColor(magnitude: magnitude)
    }
}
