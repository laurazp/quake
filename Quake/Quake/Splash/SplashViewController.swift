
import UIKit
import Lottie

class SplashViewController: UIViewController {

    @IBOutlet weak var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup Lottie animation

        animationView.loopMode = .loop
        animationView.animationSpeed = 0.7
        animationView.play()
        
        //TODO: Buscar cómo hacer fade in de la animación
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 0.5, delay: 0) {
                self.animationView.alpha = 0
            } completion: { completed in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let tabBarController = storyboard.instantiateInitialViewController() as? TabBarController {
                    self.navigationController?.setViewControllers([tabBarController], animated: false)
                }
            }
        }
        
    }
}
    
