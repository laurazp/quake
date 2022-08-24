
import Foundation
import UIKit

final class EarthquakeDetailViewModel {
    weak var viewDelegate: EarthquakeDetailViewController?
    var earthquakeModel: EarthquakeModel?
    
    private let getMagnitudeColorUseCase = GetMagnitudeColorUseCase()
    
    func assignMagnitudeColor(magnitude: Double) -> UIColor {
        return getMagnitudeColorUseCase.getMagnitudeColor(magnitude: magnitude)
    }
    
    func viewDidLoad() {
        if let earthquakeModel = earthquakeModel {
            viewDelegate?.updateView(with: earthquakeModel)
        }
    }
}
