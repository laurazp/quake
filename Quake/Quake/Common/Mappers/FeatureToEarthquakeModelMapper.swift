
import Foundation

struct FeatureToEarthquakeModelMapper {
    private let getSimplifiedTitleFormatter = GetSimplifiedTitleFormatter()
    private let getDateFormatter = GetDateFormatter()
    
    func map(from feature: Feature) -> EarthquakeModel {
        EarthquakeModel(fullTitle: feature.properties.title ?? "Unknown",
                        simplifiedTitle: getSimplifiedTitleFormatter.getSimplifiedTitle(titleWithoutFormat: feature.properties.title ?? "Unknown", place: feature.properties.place ?? "Unknown"),
                        place: feature.properties.place ?? "Unknown",
                        latitude: feature.geometry.coordinates[0],
                        longitude: feature.geometry.coordinates[1],
                        depth: feature.geometry.coordinates[2], //no debería ser opcional?
                        date: getDateFormatter.formatIntToDate(dateToFormat: feature.properties.time ?? 0000),
                        tsunami: feature.properties.tsunami ?? 0, //Formatear a string?
                        magnitude: feature.properties.mag ?? 0) //Formatear a string?
    }
}
