
import Foundation
import UIKit

final class EarthquakeDetailViewModel {
    weak var viewDelegate: EarthquakeDetailViewController?
    var earthquakeDetail: EarthquakeDetail?
    
    private let getMagnitudeColorUseCase = GetMagnitudeColorUseCase()
    
    func assignMagnitudeColor(magnitude: Double) -> UIColor {
        return getMagnitudeColorUseCase.getMagnitudeColor(magnitude: magnitude)
    }
    
    func viewDidLoad() {
        if let earthquakeDetail = earthquakeDetail {
            viewDelegate?.updateView(with: earthquakeDetail)
        }
    }
}
