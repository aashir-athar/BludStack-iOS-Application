

import UIKit


class LoginController: UIViewController {
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    private let manager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func continueButtonTapped(_ sender : UIButton){
        var phone = phoneTextField.text ?? ""
        if phone.isEmpty {
            Alerts.showAlert(on: self, title: "Error", message: "Please enter phone number.")
        }else{
            if !phone.hasPrefix("+92"){
                phone = "+92\(phone)"
            }
            registerPhone(phone: phone)
        }
    }
    
    func registerPhone(phone: String) {
        view.endEditing(true)
        manager.verifyPhone(phone: phone) { [weak self] response in
            guard let verificationId = response else {
                Alerts.showAlert(on: self, title: "Error", message: "Please enter valid phone number.")
                return
            }
            UserDefaults.phone = phone
            let controller = self?.storyboard?.instantiateViewController(identifier: "OTPController") as! OTPController
            controller.verificationId = verificationId
            self?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
