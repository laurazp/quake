
import Foundation

struct GetSimplifiedTitleFormatter {
    func getSimplifiedTitle(titleWithoutFormat: String, place: String) -> String {
        var formattedTitle: String = ""
        if (titleWithoutFormat.contains(" of ")) {
            formattedTitle = titleWithoutFormat.components(separatedBy: " of ").last ?? "Unknown"
        } else if (titleWithoutFormat.contains(" - ")) {
            let title = titleWithoutFormat.components(separatedBy: " - ")
            if (title.last != "") {
                formattedTitle = title.last ?? "Unknown"
            } else {
                formattedTitle = "Unknown"
            }
            
        } else {
            formattedTitle = place
        }
        return formattedTitle
    }
}
