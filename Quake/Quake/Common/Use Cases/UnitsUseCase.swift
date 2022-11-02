
import Foundation
import UIKit

struct UnitsUseCase {
    
    func saveSelectedUnit(selectedSegmentIndex: Int) {
        if selectedSegmentIndex == 0 {
            UserDefaults.standard.saveUnits(unit: "kilometers")
            print("Kilometers selected")
        } else {
            UserDefaults.standard.saveUnits(unit: "miles")
            print("Miles selected")
        }
    }
    
    func getSelectedUnit() -> String {
        return UserDefaults.standard.retrieveUnits()
    }
}
