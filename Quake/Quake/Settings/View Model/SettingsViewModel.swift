
import Foundation
import UIKit

final class SettingsViewModel {
    weak var viewDelegate: SettingsViewController?
    
    private let unitsUseCase = UnitsUseCase()

    // Functions to work with Units
    
    func setSelectedUnit(selectedIndex: Int) {
        unitsUseCase.saveSelectedUnit(selectedSegmentIndex: selectedIndex)
    }
    
    func getSelectedUnit() -> String {
        return unitsUseCase.getSelectedUnit()
    }
    
    func getSelectedUnit() -> Int {
        if unitsUseCase.getSelectedUnit() == "kilometers" {
            return 0
        } else {
            return 1
        }
    }
}

