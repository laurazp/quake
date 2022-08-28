
import UIKit
import Lottie
import AVFoundation

class SplashViewController: UIViewController {

    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var audioPlayer = AVAudioPlayer()
    
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
        playSound(file: "logo_sound", ext: "mp3") //TODO: Cambiar por algún sonido !!!!!
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
    
    //TODO: Modificar con sonido concreto !!!!
    private func playSound(file:String, ext:String) -> Void {
        do {
            let url = URL.init(fileURLWithPath: Bundle.main.path(forResource: file, ofType: ext)!)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch let error {
            NSLog(error.localizedDescription)
        }
    }
    
    //TODO: Copiar en info de la app!!!!! --> créditos
    // Sound Effect by <a href="https://pixabay.com/users/muzaproduction-24990238/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=music&amp;utm_content=13775">Muzaproduction</a> from <a href="https://pixabay.com/sound-effects//?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=music&amp;utm_content=13775">Pixabay</a>
    
    
}
    
