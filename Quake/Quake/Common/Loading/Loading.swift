
import Foundation
import MBProgressHUD

final class GlobalLoader {
    static func startLoading() {
        if let rootView = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController?.view {
            MBProgressHUD.showAdded(to: rootView,
                                    animated: true)
        }
    }
    
    static func stopLoading() {
        if let rootView = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController?.view {
            MBProgressHUD.hide(for: rootView,
                               animated: true)
        }
    }
}
