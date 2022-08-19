
import Foundation

struct GetTsunamiValueFormatter {
    func getTsunamiValue(tsunami: Int) -> String {
        switch (tsunami) {
        case 0:
            return "No"
        case 1:
            return "Yes"
        default:
            return "Unknown"
        }
    }
}
