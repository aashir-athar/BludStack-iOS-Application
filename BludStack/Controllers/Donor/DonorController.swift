

import UIKit
import GoogleMaps
import CoreLocation

class DonorController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bloodTypeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var mapUIView: UIView!
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var callback : ((Bool?)->())?
    
    var userId: String!
    var request: ObjectRequest!
    
    var user: ObjectUser? = nil {
        didSet{
            updateUI()
        }
    }
    var userManager = UserManager()
    var requestManager = RequestManager()
    var locationService = LocationService()
    
    var mapView: GMSMapView = GMSMapView()
    var marker = GMSMarker()
    
    @IBAction func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @IBAction func locationButtonTapped() {
        guard let userId = user?.id else {return}
        let viewController = MapViewController()
        viewController.userId = userId
        self.present(viewController, animated: true)
    }
    
    @IBAction func callButtonTapped() {
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
    
    @IBAction func cancelButtonTapped() {
        request.donorId = ""
        requestManager.create(request) { (response) in
            switch response {
            case .failure: Alerts.showAlert(on: self, title: "Error", message: "Request not updated")
            case .success: Alerts.showAlertWith(on: self, with: "Success", message: "Request updated successfully") {
                self.dismiss(animated: true) {
                    self.callback?(true)
                }
            }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        locationButton.isHidden = !(request.isOnWay ?? false)
        cancelButton.isHidden = (request.isCompleted ?? false)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.mapUIView.addSubview(mapView)
        mapView.fillSuperview()
    }
    
    func setUpUI() {
        userManager.user(for: userId) { (user) in
            self.user = user
        }
    }
    
    func updateUI() {
        nameLabel.text = user?.name
        dateOfBirthLabel.text = user?.dateOfBirth
        genderLabel.text = user?.gender
        phoneLabel.text = user?.phone
        bloodTypeLabel.text = user?.bloodGroup
        locationService.convertLatLongToAddress(latitude: user?.latitude, longitude: user?.longitude) { (address) in
            self.locationLabel.text = address
        }
        setUpMap()
    }
    
    func setUpMap() {
        //        mapView1.settings.scrollGestures = false
        //        mapView1.settings.zoomGestures = false
        //        mapView1.settings.allowScrollGesturesDuringRotateOrZoom = false
        mapView.clear()
        guard let latitude = user?.latitude, let longitude = user?.longitude else {return}
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
}
