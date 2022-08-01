//
//  EarthquakesViewModel.swift
//  Quake
//
//  Created by Laura Zafra Prat on 1/8/22.
//

import Foundation

final class EarthquakesViewModel {
    weak var viewDelegate: EarthquakeViewController?
    
    private let getEarthquakesUseCase = GetEarthquakesUseCase()
    private var earthquakesData = [Feature]()
    
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
            self.earthquakesData = features
            self.viewDelegate?.updateView()
        }
    }
}
