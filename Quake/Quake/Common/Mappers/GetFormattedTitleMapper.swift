
import Foundation

struct GetFormattedTitleMapper {
    func getFormattedTitle(titleWithoutFormat: String) -> String {
        var formattedTitle: String = ""
        if (titleWithoutFormat.contains(" of ")) {
            formattedTitle = titleWithoutFormat.components(separatedBy: " of ").last ?? "Unknown"
        } else if (titleWithoutFormat.contains(" - ")) {
            let title = formattedTitle.components(separatedBy: " - ")
            formattedTitle = title.last ?? "Unknown"
        } else {
            formattedTitle = "Unknown"
        }
        return formattedTitle
    }
}
