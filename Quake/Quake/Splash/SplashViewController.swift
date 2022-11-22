
import UIKit
import Lottie
import AVFoundation

class SplashViewController: UIViewController {
    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup Lottie animation and title
        titleLabel.alpha = 0
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.7
        animationView.alpha = 0
        animationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            UIView.animate(withDuration: 0.7, delay: 0) {
                self.titleLabel.alpha = 0
                self.animationView.alpha = 0
            } completion: { completed in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let tabBarController = storyboard.instantiateInitialViewController() as? TabBarController {
                    self.navigationController?.setViewControllers([tabBarController], animated: false)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.5, animations: {
                self.animationView.alpha = 1.0
                return
            })
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 2.5, delay: 1.5, animations: {
                self.titleLabel.alpha = 1.0
                return
            })
        }
    }
}

