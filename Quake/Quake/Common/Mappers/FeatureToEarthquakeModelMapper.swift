
import Foundation

struct FeatureToEarthquakeModelMapper {
    private let getSimplifiedTitleFormatter = GetSimplifiedTitleFormatter()
    private let getFormattedCoordsFormatter = GetFormattedCoordsFormatter()
    private let getTsunamiValueFormatter = GetTsunamiValueFormatter()
    private let getDateFormatter = GetDateFormatter()
    
    func map(from feature: Feature) -> EarthquakeModel {
        EarthquakeModel(fullTitle: feature.properties.title ?? "Unknown",
                        simplifiedTitle: getSimplifiedTitleFormatter.getSimplifiedTitle(titleWithoutFormat: feature.properties.title ?? "Unknown", place: feature.properties.place ?? "Unknown"),
                        place: feature.properties.place ?? "Unknown",
                        formattedCoords: getFormattedCoordsFormatter.getFormattedCoords(actualCoords: feature.geometry.coordinates),
                        originalCoords: feature.geometry.coordinates,
                        depth: "\(String(feature.geometry.coordinates[2]))km", //no debería ser opcional?
                        date: getDateFormatter.formatDate(dateToFormat: feature.properties.time ?? 0000),
                        originalDate: getDateFormatter.formatIntToDate(dateToFormat: feature.properties.time ?? 0),
                        tsunami: getTsunamiValueFormatter.getTsunamiValue(tsunami: feature.properties.tsunami ?? 0),
                        magnitude: String(format: "%.1f", feature.properties.mag ?? 0))
    }
}
