//
//  TabBarController.swift
//  Quake
//
//  Created by Laura Zafra Prat on 13/6/22.
//

import UIKit

class TabBarController: UITabBarController {
    @IBInspectable var initialIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = initialIndex
        let earthquakes = getEarthquakesViewController()
        let map = getMapViewController()
        viewControllers = [earthquakes, map]
    }
    
    private func getMapViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "MapStoryboard", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MapViewController")
        viewController.title = "Map"
        let navigationController = UINavigationController(rootViewController: viewController) // TODO: Explicar navigation controller
        navigationController.tabBarItem.image = UIImage(systemName: "map")
        return navigationController
    }
    
    private func getEarthquakesViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "EarthquakesStoryboard", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()!
        viewController.title = "Earthquakes"
        let navigationController = UINavigationController(rootViewController: viewController) // TODO: Explicar navigation controller
        navigationController.tabBarItem.image = UIImage(systemName: "house")
        return navigationController
    }
}
