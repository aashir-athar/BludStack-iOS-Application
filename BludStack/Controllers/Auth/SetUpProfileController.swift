

import UIKit
import GooglePlaces

class SetUpProfileController: UIViewController {
    
    
    //MARK:- Outlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dateOfBirthField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    
    @IBOutlet weak var bloodGroupField: UITextField!
    
    @IBOutlet weak var isDonorSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    
    //MARK:- Variables
    private let imageService = ImagePickerService()
    private let manager = UserManager()
    private var selectedImage: UIImage? = nil
    
    var isUpdate = false
    
    private let bloodTypePickerView = UIPickerView()
    private let bloodTypes = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
    private var selectedBloodType: Int = 0
    
    private let pickerView = UIPickerView()
    private var sellectedIndex: Int = 0
    private let genders = ["Male", "Female", "Prefer not to say"]
    
    private var city = ""
    
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        userImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.userImageTapped(_:))))
        userImage.isUserInteractionEnabled = true
        dateOfBirthField.addInputViewDatePicker(target: self, selector: #selector(dateOfBirthSellected))
        genderField.inputView = pickerView
        genderField.addToolbar(target: self, selector: #selector(genderSellected))
        locationField.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        
        bloodGroupField.inputView = bloodTypePickerView
        bloodGroupField.addToolbar(target: self, selector: #selector(bloodTypeSellected))
        bloodTypePickerView.delegate = self
        bloodTypePickerView.dataSource = self
        
        if isUpdate{
            saveButton.setTitle("Update", for: .normal)
            manager.userData(for: UserDefaults.userId) { [self] (user) in
                nameField.text = user?.name
                city = user?.city ?? ""
                locationField.text = user?.location
                bloodGroupField.text = user?.bloodGroup
                dateOfBirthField.text = user?.dateOfBirth
                genderField.text = user?.gender
                isDonorSwitch.setOn(user?.isDonor ?? false, animated: true)
            }
        }else{
            saveButton.setTitle("Sign Up", for: .normal)
        }
        
    }
    
    func getCountries() -> [String] {
        NSLocale.isoCountryCodes.map { (code:String) -> String in
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            return NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
        }
    }
    
    @objc func userImageTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        imageService.pickImage(from: self) {[weak self] image in
            self?.userImage.image = image
            self?.selectedImage = image
        }
    }
    @objc func genderSellected() {
        genderField.text = genders[sellectedIndex]
        genderField.resignFirstResponder()
    }
    @objc func bloodTypeSellected() {
        bloodGroupField.text = bloodTypes[selectedBloodType]
        bloodGroupField.resignFirstResponder()
    }
    
    @IBAction func saveUserButtonTapped(_ sender: Any) {
        
        let name = nameField.text ?? ""
        let location = locationField.text ?? ""
        let dateOfBirth = dateOfBirthField.text ?? ""
        let gender = genderField.text ?? ""
        let bloodGroup = bloodGroupField.text ?? ""
        
        let dob = dateOfBirth.toDate() ?? Date()
        
        if name.isEmpty{
            Alerts.showAlert(on: self, title: "Error", message: "Please enter name.")
        }else if name.isValidName(){
            Alerts.showAlert(on: self, title: "Error", message: "Please enter valid name.")
        }else if location.isEmpty{
            Alerts.showAlert(on: self, title: "Error", message: "Please enter location.")
        }else if city.isEmpty{
            Alerts.showAlert(on: self, title: "Error", message: "Please select diferent location, we are unable to get city.")
        }else if dateOfBirth.isEmpty{
            Alerts.showAlert(on: self, title: "Error", message: "Please select date of birth.")
        }else if dob.millisecondsSince1970 >= Date().millisecondsSince1970 {
            Alerts.showAlert(on: self, title: "Error", message: "Please select valid date of birth.")
        }else if Date().years(from: dob) < 18 {
            Alerts.showAlert(on: self, title: "Error", message: "Your age is not eligible.")
        }else if gender.isEmpty{
            Alerts.showAlert(on: self, title: "Error", message: "Please select gender.")
        }else if bloodGroup.isEmpty{
            Alerts.showAlert(on: self, title: "Error", message: "Please enter blood group.")
        }else{
            view.endEditing(true)
            let user = ObjectUser()
            user.id = UserDefaults.userId
            user.name = name
            user.location = location
            user.gender = gender
            user.dateOfBirth = dateOfBirth
            user.bloodGroup = bloodGroup
            user.phone = UserDefaults.phone
            user.profilePic = selectedImage
            user.isDonor = isDonorSwitch.isOn
            user.city = city
            manager.update(user: user) { (response) in
                switch response {
                case .failure: Alerts.showAlert(on: self, title: "Error", message: "User not saved")
                case .success:
                    UserDefaults.isDonor = self.isDonorSwitch.isOn
                    UserDefaults.bloodGroup = bloodGroup
                    UserDefaults.userName = name
                    UserDefaults.city = self.city
                    AppDelegate.shared.openHomeController()
                }
            }
        }
    }
}

extension SetUpProfileController{
    @objc func dateOfBirthSellected() {
        if let  datePicker = self.dateOfBirthField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.dateformat
            self.dateOfBirthField.text = dateFormatter.string(from: datePicker.date)
        }
        self.dateOfBirthField.resignFirstResponder()
    }
}



// MARK:- UIPickerViewDelegate/UIPickerViewDataSource
extension SetUpProfileController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == bloodTypePickerView{
            return bloodTypes.count
        }else{
            return genders.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == bloodTypePickerView{
            return bloodTypes[row]
        }else{
            return genders[row]
        }
        
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == bloodTypePickerView{
            selectedBloodType = row
        }else{
            sellectedIndex = row
        }
    }
    
}

// MARK:- UITextFieldDelegate
extension SetUpProfileController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == locationField{
            view.endEditing(true)
            let placePickerController = GMSAutocompleteViewController()
            placePickerController.delegate = self
            present(placePickerController, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}


// MARK:- GMSAutocompleteViewControllerDelegate
extension SetUpProfileController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place lat: \(place.coordinate.latitude)")
        print("Place lon: \(place.coordinate.longitude)")
        print("Place address: \(String(describing: place.formattedAddress))")
        
        locationField.text = place.formattedAddress
//        city = place.addressComponents?.first(where: { $0.type == "city" })?.name ?? ""
        for component in place.addressComponents! {
            if component.type == "administrative_area_level_2" {
                city = component.name
            }
           }
        print("City: \(city)")
//        latitude = place.coordinate.latitude
//        longitude = place.coordinate.longitude
        dismiss(animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        
    }
    
}
