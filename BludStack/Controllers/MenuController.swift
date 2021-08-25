

import UIKit

class MenuController: UIViewController {

    @IBOutlet weak var donationsView: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let userManager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        donationsView.isHidden = !UserDefaults.isDonor
        nameLabel.text = UserDefaults.userName
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func requestsButtonTapped() {
        let controller = RequestsController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func donationsButtonTapped() {
        let controller = DonationsController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func settingsButtonTapped() {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SetUpProfileController") as! SetUpProfileController
        viewController.isUpdate = true
        self.present(viewController, animated: true)
    }
    
    
    
    @IBAction func logoutButtonTapped() {
        userManager.logout()
        AppDelegate.shared.openLoginController()
    }
}
