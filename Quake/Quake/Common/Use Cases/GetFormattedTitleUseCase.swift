
import Foundation

struct GetFormattedTitleUseCase {
    func getFormattedTitle(titleWithoutFormat: String) -> String {
        var formattedTitle: String = ""
        if (titleWithoutFormat.contains(" of ")) {
            formattedTitle = titleWithoutFormat.components(separatedBy: " of ").last ?? "Unknown"
        } else {
            let title = formattedTitle.components(separatedBy: " - ")
            formattedTitle = title.last ?? "Unknown"
        }
        return formattedTitle
    }
}
