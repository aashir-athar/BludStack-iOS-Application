

import UIKit
import GoogleMaps
import FloatingPanel
import CoreLocation
import GooglePlaces

class SelectLocationController: UIViewController {
    
    let mapView = GMSMapView()
    var marker = GMSMarker()
    let locationService = LocationService()
    let panel = FloatingPanelController()
    private var city = ""
    private var address = ""
    var gmsAutoCompleteViewController = GMSAutocompleteViewController()
    var location: CLLocationCoordinate2D? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backTapped))
        title = "Select Location"
        view.backgroundColor = .white
        view.addSubview(mapView)
        mapView.delegate = self
        
        
        
        let navigationController = UINavigationController(rootViewController: gmsAutoCompleteViewController)
        //        searchController.navigationController?.setNavigationBarHidden(true, animated: true)
        //       panel.navigationController?.setNavigationBarHidden(true, animated: true)
        //        searchController.navigationController?.navigationBar.prefersLargeTitles = false
        //        searchController.navigationController?.title = "Select Location"
        gmsAutoCompleteViewController.delegate = self
        
        panel.set(contentViewController: navigationController)
        panel.addPanel(toParent: self)
        self.panel.move(to: .full, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: NSNotification.Name(rawValue: "Request"), object: nil)
        
        locationService.getLocation {[weak self] response in
            switch response {
            case .denied:
                self?.showAlert(title: "Error", message: "Please enable location services")
            case .location(let location):
                self?.location = location
                self?.setUpMapView()
                self?.setAddress()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "Request"), object: nil)
    }
    
    @objc func onDidReceiveData(_ notification: Notification) {
        dismiss(animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }
    @objc func backTapped() {
        dismiss(animated: true)
    }
    @objc func nextTapped() {
        if UserDefaults.city == ""{
            Alerts.showAlert(on: self, title: "Error", message: "Please select save your location in user settings.")
        }else if city == ""{
            Alerts.showAlert(on: self, title: "Error", message: "Please select diferent location, we are unable to get city.")
        }else if !city.lowercased().contains(UserDefaults.city.lowercased()){
            Alerts.showAlert(on: self, title: "Error", message: "Please select location within your city or maybe we're unable to get city.")
        }else{
            guard let location = location else {return}
            CreateRequestController.showPopup(parentVC: self, location: location, city: city, address: address)
        }
    }
    
    func setUpMapView() {
        mapView.clear()
        self.panel.move(to: .tip, animated: false)
        guard let latitude = location?.latitude, let longitude = location?.longitude else {return}
        print("New location", latitude, longitude)
        marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        //        marker.title = "Sydney"
        //        marker.snippet = "Australia"
        
        marker.map = mapView
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    }
    
    func setAddress() {
        guard let latitude = location?.latitude, let longitude = location?.longitude else {return}
        city = ""
        address = ""
        locationService.convertLatLongToAddress(latitude: latitude, longitude: longitude) { address in
            self.city = address
            self.address = address
        }
    }
}

extension SelectLocationController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.location = coordinate
        setUpMapView()
        setAddress()
    }
}


// MARK:- GMSAutocompleteViewControllerDelegate
extension SelectLocationController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        city = ""
        self.address = place.formattedAddress ?? ""
        for component in place.addressComponents! {
            if component.type == "administrative_area_level_2" {
                city = component.name
            }
        }
        self.location = place.coordinate
        setUpMapView()
        print("City: \(city)")
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


//extension SelectLocationController: SearchControllerDelegate {
//    func searchController(_ vc: SearchController, didSelectLocationWith coordinates: CLLocationCoordinate2D?) {
//        self.location = coordinates
//
//    }
//}
