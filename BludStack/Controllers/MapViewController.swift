

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.red
        button.setTitle("Cancel", for: .normal)
        return button
    }()
    
    var latitude: Double! = 0.0
    var longitude: Double! = 0.0
    
    var userId: String? = nil
    var userManager = UserManager()
    var mapView: GMSMapView = GMSMapView()
    var marker = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userId = userId{
            getUser(userId: userId)
        }
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 16)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        setUpMapView()
        
        self.view.addSubview(mapView)
        cancelButton.addTarget(self, action: #selector(self.cancelButtonTapped), for: .touchUpInside)
        self.view.addSubview(cancelButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cancelButton.frame = CGRect(x:0, y:0, width: self.view.frame.size.width-40, height:50)
        cancelButton.frame.origin = CGPoint(x:20, y:Int(self.view.frame.size.height - cancelButton.frame.size.height) - 40)
    }
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    func getUser(userId: String) {
        userManager.user(for: userId) { (user) in
            guard let latitude = user?.latitude, let longitude = user?.longitude else {return}
            if self.latitude != longitude && self.longitude != longitude{
                self.latitude = latitude
                self.longitude = longitude
                self.setUpMapView()
            }
        }
    }
    
    func setUpMapView() {
        mapView.clear()
        guard let latitude = latitude, let longitude = longitude else {return}
        print("New location", latitude, longitude)
        marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        //        marker.title = "Sydney"
        //        marker.snippet = "Australia"
        
        marker.map = mapView
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    }
}
