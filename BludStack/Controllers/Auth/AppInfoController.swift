

import UIKit

class AppInfoController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    @IBAction func nextButtonTapped(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "LoginController") as! LoginController
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
