
import Foundation

struct FeatureToEarthquakeModelMapper {
    private let getSimplifiedTitleFormatter = GetSimplifiedTitleFormatter()
    private let getFormattedCoordsFormatter = GetFormattedCoordsFormatter()
    private let getTsunamiValueFormatter = GetTsunamiValueFormatter()
    private let getDateFormatter = GetDateFormatter()
    private let unitsUseCase = UnitsUseCase()
    
    func map(from feature: Feature) -> EarthquakeModel {
        EarthquakeModel(fullTitle: feature.properties.title ?? "Unknown",
                        simplifiedTitle: getSimplifiedTitleFormatter.getSimplifiedTitle(titleWithoutFormat: feature.properties.title ?? "Unknown", place: feature.properties.place ?? "Unknown"),
                        place: feature.properties.place ?? "Unknown",
                        formattedCoords: getFormattedCoordsFormatter.getFormattedCoords(actualCoords: feature.geometry.coordinates),
                        originalCoords: feature.geometry.coordinates,
                        depth: "\(depthInSelectedUnits(feature: feature))",
                        date: getDateFormatter.formatDate(dateToFormat: feature.properties.time ?? 0000),
                        originalDate: getDateFormatter.formatIntToDate(dateToFormat: feature.properties.time ?? 0),
                        tsunami: getTsunamiValueFormatter.getTsunamiValue(tsunami: feature.properties.tsunami ?? 0),
                        magnitude: String(format: "%.1f", feature.properties.mag ?? 0))
    }
    
    func depthInSelectedUnits(feature: Feature) -> Measurement<UnitLength> {
        let initialDepthInKms = Double(feature.geometry.coordinates[2]).roundToDecimal(2)
        var finalDepth = Measurement(value: 0.0, unit: UnitLength.kilometers)
        if (unitsUseCase.getSelectedUnit() == "kilometers") {
            finalDepth = Measurement(value: initialDepthInKms, unit: UnitLength.kilometers)
        } else {
            finalDepth = Measurement(value: (initialDepthInKms * 0.62137), unit: UnitLength.miles)
        }
        return finalDepth
    }
}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
