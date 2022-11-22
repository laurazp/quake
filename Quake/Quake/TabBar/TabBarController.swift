
import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    @IBInspectable var initialIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = initialIndex
        let earthquakes = getEarthquakesViewController()
        let map = getMapViewController()
        let settings = getSettingsViewController()
        viewControllers = [earthquakes, map, settings]
        navigationController?.navigationBar.isHidden = true
        delegate = self
        setupTabBar()
    }
    
    func setupTabBar() {
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.shadowOffset = CGSize.zero
        tabBar.layer.shadowRadius = 5
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.layer.borderWidth = 0
        self.tabBar.clipsToBounds = false
        self.tabBar.backgroundColor = UIColor.white
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }
    
    private func getMapViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "MapStoryboard", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else {
            return UIViewController()
        }
        viewController.title = "Map"
        viewController.viewModel.viewDelegate = viewController
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = UIImage(systemName: "map")
        return navigationController
    }
    
    private func getEarthquakesViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "EarthquakesStoryboard", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? EarthquakeViewController else {
            return UIViewController()
        }
        viewController.title = "Quake"
        viewController.viewModel.viewDelegate = viewController
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = UIImage(systemName: "house")?.withAlignmentRectInsets(UIEdgeInsets(top: 8.5, left: 0, bottom: -8.5, right: 0))
        return navigationController
    }
    
    private func getSettingsViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "SettingsStoryboard", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
        viewController.title = "Settings"
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = UIImage(systemName: "wrench.and.screwdriver")
        return navigationController
    }
    
}
