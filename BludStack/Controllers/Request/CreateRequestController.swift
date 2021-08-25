

import UIKit
import CoreLocation

class CreateRequestController: UIViewController {
    
    static let identifier = "NormalPopupViewController"
    
    //MARK:- outlets for the viewController
    @IBOutlet weak var dialogBoxView: UIView!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var bloodGroupField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    
    private let bloodTypePickerView = UIPickerView()
    private let bloodTypes = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
    private var selectedBloodType: Int = 0
    
    var location: CLLocationCoordinate2D!
    var city: String!
    var address: String!
    private let userManager = UserManager()
    let locationService = LocationService()
    private let manager = RequestManager()
    
    //MARK:- lifecyle methods for the view controller
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //adding an overlay to the view to give focus to the dialog box
        view.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        
        //customizing the dialog box view
        dialogBoxView.layer.cornerRadius = 6.0
//        locationService.convertLatLongToAddress(latitude: location.latitude, longitude: location.longitude) { [self] (address) in
//            locationField.text = address
//        }
        locationField.text = address
        dateField.addInputViewDatePicker(target: self, selector: #selector(dateSellected))
        timeField.addInputViewDatePicker(target: self, selector: #selector(timeSellected), datePickerMode: .time)
        
        bloodGroupField.inputView = bloodTypePickerView
        bloodGroupField.addToolbar(target: self, selector: #selector(bloodTypeSellected))
        bloodTypePickerView.delegate = self
        bloodTypePickerView.dataSource = self
    }
    
    @objc func bloodTypeSellected() {
        bloodGroupField.text = bloodTypes[selectedBloodType]
        bloodGroupField.resignFirstResponder()
    }
    
    //MARK:- outlet functions for the viewController
    @IBAction func continueButtonTapped(_ sender: Any) {
        let bloodGroup = bloodGroupField.text ?? ""
        let date = dateField.text ?? ""
        let time = timeField.text ?? ""
        let format = Constants.dateformat + " " + Constants.timeformat
        let d = (date+" "+time).toDate(format: format) ?? Date()
        print("Date:: ", d, (date+" "+time))
        print(d.millisecondsSince1970 < Date().toLocalTime().millisecondsSince1970)
        print(d.millisecondsSince1970, Date().toLocalTime().millisecondsSince1970)
        if date.isEmpty{
            Alerts.showAlert(on: self, title: "Error", message: "Please select date")
        }else if d.millisecondsSince1970 < Date().toLocalTime().millisecondsSince1970 {
            Alerts.showAlert(on: self, title: "Error", message: "Please select valid date.")
        }else if d.millisecondsSince1970 > (Date().toLocalTime().millisecondsSince1970+2592000000) {
            Alerts.showAlert(on: self, title: "Error", message: "Please select date less than 30 days.")
        }else if time.isEmpty{
            Alerts.showAlert(on: self, title: "Error", message: "Please select time.")
        }else if UserDefaults.city == ""{
            Alerts.showAlert(on: self, title: "Error", message: "Please select save your location in user settings.")
        }else if !city.lowercased().contains(UserDefaults.city.lowercased()){
            Alerts.showAlert(on: self, title: "Error", message: "Please select location within your city.")
        }else if bloodGroup.isEmpty{
            Alerts.showAlert(on: self, title: "Error", message: "Please enter blood group.")
        }else{
            view.endEditing(true)
            let request = ObjectRequest()
            request.userId = UserDefaults.userId
            request.date = date
            request.time = time
            request.latitude = location.latitude
            request.longitude = location.longitude
            request.bloodGroup = bloodGroup
            request.timestamp = date.toDate()?.millisecondsSince1970
            request.city = city
            manager.create(request) { (response) in
                switch response {
                case .failure: Alerts.showAlert(on: self, title: "Error", message: "Request not saved")
                case .success: Alerts.showAlertWith(on: self, with: "Success", message: "Request generated successfully") {
                    self.dismiss(animated: true) {
                        NotificationCenter.default.post(name: Notification.Name("Request"), object: nil, userInfo: [:])
                    }
                }
                }
            }
            
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dateSellected() {
        if let  datePicker = self.dateField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.dateformat
            self.dateField.text = dateFormatter.string(from: datePicker.date)
        }
        self.dateField.resignFirstResponder()
    }
    @objc func timeSellected() {
        if let  datePicker = self.timeField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.timeformat
            self.timeField.text = dateFormatter.string(from: datePicker.date)
        }
        self.timeField.resignFirstResponder()
    }
    
    //MARK:- functions for the viewController
    static func showPopup(parentVC: UIViewController, location: CLLocationCoordinate2D, city: String, address: String){
        //creating a reference for the dialogView controller
        if let popupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateRequestController") as? CreateRequestController {
            popupViewController.modalPresentationStyle = .custom
            popupViewController.modalTransitionStyle = .crossDissolve
            //presenting the pop up viewController from the parent viewController
            popupViewController.location = location
            popupViewController.city = city
            popupViewController.address = address
            parentVC.present(popupViewController, animated: true)
        }
    }
}

// MARK:- UIPickerViewDelegate/UIPickerViewDataSource
extension CreateRequestController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bloodTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bloodTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedBloodType = row
    }
    
}
