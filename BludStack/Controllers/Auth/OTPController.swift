

import UIKit
import OTPFieldView

class OTPController: UIViewController {
    
    @IBOutlet weak var otpFieldView: OTPFieldView!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var counterButton: UIButton!
    
    private let manager = UserManager()
    var verificationId: String!
    var otpString = ""
    var timer : Timer? = nil
    var count = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOtpView()
        resendButton.setTitle("Resend code in 00:", for: .normal)
        counterButton.setTitle("\(count)", for: .normal)
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(resendTimer), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    @objc func resendTimer()
    {
        count-=1
        if count == 0{
            timer?.invalidate()
            timer = nil
            resendButton.setTitle("Resend code", for: .normal)
            counterButton.setTitle("", for: .normal)
        }else{
            counterButton.setTitle("\(count)", for: .normal)
        }
        
    }
    
    @IBAction func backButtonTapped(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resendButtonTapped(_ sender : UIButton){
        if timer == nil{
            guard let phone = UserDefaults.phone else {return}
            manager.verifyPhone(phone: phone) { [self] response in
                guard let verificationId = response else {
                    Alerts.showAlert(on: self, title: "Error", message: "Please enter valid phone number.")
                    return
                }
                count = 30
                resendButton.setTitle("Resend code in 00:", for: .normal)
                counterButton.setTitle("\(count)", for: .normal)
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(resendTimer), userInfo: nil, repeats: true)
                self.verificationId = verificationId
            }
        }
    }
    
    @IBAction func doneButtonTapped(_ sender : UIButton){
        if otpString.isEmpty {
            Alerts.showAlert(on: self, title: "Error", message: "Please enter OTP.")
        }else{
            signIn()
        }
    }
    
}

extension OTPController {
    
    func signIn(){
        manager.login(verificationId: verificationId, verificationCode: otpString) { [weak self] (response) in
            switch response {
            case .failure: Alerts.showAlert(on: self, title: "Error", message: "Invalid OTP.")
            case .success: self?.getUser()
            }
        }
    }
    
    func getUser() {
        guard let userId = manager.currentUserID() else {
            return
        }
        UserDefaults.userId = userId
        
        manager.userData(for: userId) { [weak self] (user) in
            guard user != nil else {
                let controller = self?.storyboard?.instantiateViewController(identifier: "SetUpProfileController") as! SetUpProfileController
                self?.navigationController?.pushViewController(controller, animated: true)
              return
            }
            UserDefaults.isDonor = user?.isDonor ?? false
            UserDefaults.bloodGroup = user?.bloodGroup ?? ""
            UserDefaults.city = user?.city ?? ""
            AppDelegate.shared.openHomeController()
            
        }
    }
}


extension OTPController : OTPFieldViewDelegate {
    func setupOtpView(){
        self.otpFieldView.fieldsCount = 6
        self.otpFieldView.fieldBorderWidth = 2
        self.otpFieldView.defaultBorderColor = UIColor.black
        self.otpFieldView.filledBorderColor = UIColor.green
        self.otpFieldView.cursorColor = UIColor.red
        self.otpFieldView.displayType = .underlinedBottom
        self.otpFieldView.fieldSize = 40
        self.otpFieldView.separatorSpace = 8
        self.otpFieldView.shouldAllowIntermediateEditing = false
        self.otpFieldView.delegate = self
        self.otpFieldView.initializeUI()
    }
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        print("OTPString: \(otpString)")
        self.otpString = otpString
    }
}
