
import Foundation
import Lottie

class LaunchSceenViewController: UIViewController {
    var animationView: AnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup Lottie animation
        animationView = .init(name: "map-pin-animation")
        animationView?.frame = view.bounds
        animationView?.loopMode = .loop
        animationView?.animationSpeed = 0.7
        view.addSubview(animationView!)
        animationView?.play()
    }
}
    
