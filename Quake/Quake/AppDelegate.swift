
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window
        
        let storyboard = UIStoryboard(name: "Splash", bundle: nil)
        if let splashViewController = storyboard.instantiateInitialViewController() as? SplashViewController {
            navigationController = UINavigationController(rootViewController: splashViewController)
            window.rootViewController = navigationController
        }

        return true
    }
}

