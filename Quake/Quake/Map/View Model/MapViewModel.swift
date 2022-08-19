
import Foundation
import UIKit
import MapKit


final class MapViewModel {
    weak var viewDelegate: MapViewController?
    
    private let getEarthquakesUseCase = GetEarthquakesUseCase()
    private var earthquakesData = [Feature]()
    private let getMagnitudeColorUseCase = GetMagnitudeColorUseCase()
    private let getDateFormatter = GetDateFormatter()
    
    func viewDidLoad() {
        getEarthquakes()
    }
    
    func getFeature(at index: Int) -> Feature {
        earthquakesData[index]
    }
    
    func numberOfItems() -> Int {
        earthquakesData.count
    }
    
    private func getEarthquakes() {
        getEarthquakesUseCase.getEarthquakes { features in
            //self.earthquakesData = features
            let annotations: [AnnotationInMap] = features.map { feature in
                AnnotationInMap(title: feature.properties.title,
                                place: feature.properties.place,
                                time: self.getDateFormatter.formatIntToDate(dateToFormat: feature.properties.time ?? 0),
                                mag: feature.properties.mag,
                                tsunami: feature.properties.tsunami,
                                coordinate: CLLocationCoordinate2D(latitude:  CLLocationDegrees(feature.geometry.coordinates[1]),
                                                                   longitude: CLLocationDegrees(feature.geometry.coordinates[0])),
                                depth: feature.geometry.coordinates[2])
            }
            self.viewDelegate?.updateView(annotationsInMap: annotations)
        }
    }
    
    //TODO: Mover cambio color de pines aquí?
    func assignPinColor(magnitude: Double) -> UIColor {
        return getMagnitudeColorUseCase.getMagnitudeColor(magnitude: magnitude)
    }
}
