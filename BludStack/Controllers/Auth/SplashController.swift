

import UIKit

class SplashController: UIViewController {
    
    private let manager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard UserDefaults.userId != "" else {
            AppDelegate.shared.openLoginController()
            return
        }
        print(UserDefaults.userId)
        manager.userData(for: UserDefaults.userId) { (user) in
            guard user != nil else {
                AppDelegate.shared.openSetUpProfileController()
              return
            }
            AppDelegate.shared.openHomeController()
        }
    }

}
