
import Foundation

extension UserDefaults {
    
    func saveUnits(unit: String) {
        UserDefaults.standard.set(unit, forKey: "Units")
    }
    
    func retrieveUnits() -> String {
        if (UserDefaults.standard.object(forKey: "Units") as? String != nil) {
            return UserDefaults.standard.object(forKey: "Units") as! String
        } else {
            return "kilometers"
        }
    }
}

