

import UIKit
import GoogleMaps
import CoreLocation

class RequestDetailController: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var bloodTypeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mapUIView: UIView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var urgentButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var donorButton: UIButton!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var onMyWayButton: UIButton!
    
    // MARK:- Variables
    let locationService = LocationService()
    let userManager = UserManager()
    let requestManager = RequestManager()
    var requestId: String!
    var request: ObjectRequest? = nil {
        didSet{
            setUpUI()
            updateUI()
            setUpMap()
        }
    }
    var mapView: GMSMapView = GMSMapView()
    var marker = GMSMarker()
    var recipient: ObjectUser?
    var donor: ObjectUser?
    var timer : Timer? = nil
    
    // MARK:- Actions
    
    @IBAction func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @IBAction func donorButtonTapped() {
        guard let userId = request?.donorId else {return}
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DonorController") as! DonorController
        viewController.userId = userId
        viewController.request = request
        viewController.callback = { cancel in
            if cancel ?? false {
                self.request?.donorId = ""
                self.setUpUI()
            }
        }
        self.present(viewController, animated: true)
    }
    
    @IBAction func urgentButtonTapped() {
        request?.isUrgent = true
        updateRequest()
    }
    @IBAction func onMyWayButtonTapped() {
        if request?.isOnWay == true{
            request?.isOnWay = false
            updateRequest()
            onMyWayButton.setTitle("On my way!", for: .normal)
            timer?.invalidate()
        }else{
            request?.isOnWay = true
            updateRequest()
            updateLocation()
            onMyWayButton.setTitle("Reached or could not come!", for: .normal)
        }
        
    }
    
    @IBAction func acceptButtonTapped() {
        userManager.userData(for: UserDefaults.userId) { (user) in
            let lastDonation = user?.lastDonation ?? 0
            print(Date().millisecondsSince1970 - lastDonation, 7889400000)
            if ( Date().millisecondsSince1970 - lastDonation) > 7889400000{
                self.request?.donorId = UserDefaults.userId
                self.updateRequest()
            }else{
                Alerts.showAlert(on: self, title: "Sorry!", message: "Thanks for your help but you have donated within last three months.")
            }
        }
    }
    
    @IBAction func cancelButtonTapped() {
        if request?.donorId == UserDefaults.userId{
            // donor
            request?.donorId = ""
            updateRequest()
        }else{
            // delete
            guard let request = request else {return}
            requestManager.delete(request){ (response) in
                switch response {
                case .failure: Alerts.showAlert(on: self, title: "Error", message: "Request not deleted")
                case .success:
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    @IBAction func callButtonTapped() {
        guard let userId = request?.userId else {return}
        userManager.userData(for: userId) { (user) in
            let appURLString = "tel:\(user?.phone ?? "")"
            print(appURLString)
            if let url = URL(string: appURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }else{
                print("Invalid URL")
            }
        }
    }
    
    @IBAction func completedButtonTapped() {
        
        guard let user = donor else {
            Alerts.showAlert(on: self, title: "Error", message: "Please cancel the request because there is no donor associated with this request.")
            return
        }
        request?.isCompleted = true
        user.lastDonation = Date().millisecondsSince1970
        userManager.update(user: user) { (response) in
            switch response {
            case .failure: Alerts.showAlert(on: self, title: "Error", message: "User not saved")
            case .success:
                self.updateRequest()
            }
        }
    }
    
    @IBAction func locationButtonTapped() {
        guard let latitude = request?.latitude, let longitude = request?.longitude else {return}
        let viewController = MapViewController()
        viewController.latitude = latitude
        viewController.longitude = longitude
        self.present(viewController, animated: true)
    }
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        requestManager.requestData(for: requestId) { (request) in
            self.request = request
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.mapUIView.addSubview(mapView)
        mapView.fillSuperview()
        
    }
    
}

// MARK:- Implementation
extension RequestDetailController{
    func setUpUI(){
        completedLabel.isHidden = !(request?.isCompleted ?? false)
        donorButton.isHidden = !((request?.donorId ?? "") != "") || ((request?.donorId ?? "") == UserDefaults.userId)
        urgentButton.isHidden = true
        cancelButton.isHidden = true
        acceptButton.isHidden = true
        completedButton.isHidden = true
        onMyWayButton.isHidden = true
        callButton.isHidden = (request?.userId ?? "") == UserDefaults.userId
        if (request?.isUrgent ?? false){
            completedLabel.isHidden = false
            completedLabel.text = "Urgent!"
        }
        if request?.donorId != "" {
            completedLabel.isHidden = false
            completedLabel.text = "Accepted!"
        }
        if request?.isCompleted ?? false {
            completedLabel.isHidden = false
            completedLabel.text = "Completed!"
        }
        if !(request?.isCompleted ?? false){
            
            if request?.userId == UserDefaults.userId{
                completedButton.isHidden = false
            }
            
            if request?.userId == UserDefaults.userId && !(request?.isUrgent ?? false){
                urgentButton.isHidden = false
            }
            
            if request?.userId == UserDefaults.userId || request?.donorId == UserDefaults.userId{
                cancelButton.isHidden = false
            }
            
            if request?.donorId == UserDefaults.userId{
                onMyWayButton.isHidden = false
            }
            
            if request?.userId != UserDefaults.userId && (request?.donorId ?? "") == ""{
                acceptButton.isHidden = false
            }
            if request?.userId == UserDefaults.userId{
                cancelButton.setTitle("Delete", for: .normal)
            }else{
                cancelButton.setTitle("Cancel", for: .normal)
            }
            
        }
    }
    
    func updateUI() {
        locationService.convertLatLongToAddress(latitude: request?.latitude, longitude: request?.longitude) { [self] (address) in
            locationLabel.text = address
        }
        bloodTypeLabel.text = request?.bloodGroup
        timeLabel.text = request?.time
        dateLabel.text = request?.date
        let donorId = request?.donorId ?? ""
        if donorId != ""{
            guard let userId = request?.donorId else {return}
            userManager.userData(for: userId) { (user) in
                self.donor = user
            }
        }
    }
    
    func setUpMap() {
        //        mapView1.settings.scrollGestures = false
        //        mapView1.settings.zoomGestures = false
        //        mapView1.settings.allowScrollGesturesDuringRotateOrZoom = false
        mapView.clear()
        guard let latitude = request?.latitude, let longitude = request?.longitude else {return}
        let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), zoom: 16)
        mapView = GMSMapView.map(withFrame: mapView.frame, camera: camera)
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        //        marker.title = "Sydney"
        //        marker.snippet = "Australia"
        marker.map = mapView
        mapView.animate(toLocation: marker.position)
        view.bringSubviewToFront(backButton)
    }
    
    func updateRequest(){
        guard let request = request else {return}
        requestManager.create(request) { (response) in
            switch response {
            case .failure: Alerts.showAlert(on: self, title: "Error", message: "Request not updated")
            case .success: self.setUpUI()
            }
        }
    }
}


extension RequestDetailController{
    @objc func updateLocation() {
        guard let user = donor else {return}
        getLocation{ [self] location in
            if location.latitude != user.latitude && location.longitude != user.latitude{
                user.latitude = location.latitude
                user.longitude = location.longitude
                self.updateUser(user: user)
            }else{
                print("user not moving")
                self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: false)
            }
        }
    }
    
    func updateUser(user: ObjectUser){
        userManager.update(user: user) { [self] (response) in
            switch response {
            case .failure:
                print("location not updated")
                self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: false)
            case .success:
                print("location updated")
                self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: false)
            }
        }
    }
    
    func getLocation(_ completion: @escaping (CLLocationCoordinate2D)->Void) {
        locationService.getLocation {[weak self] response in
            switch response {
            case .denied:
                self?.showAlert(title: "Error", message: "Please enable location services")
            case .location(let location):
                completion(location)
            }
        }
    }
    
}
