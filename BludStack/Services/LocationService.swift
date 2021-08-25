
import CoreLocation

struct Location {
    let title: String
    let coordinates: CLLocationCoordinate2D?
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    private lazy var manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
    }()
    private var hasSentLocation = false
    var completion: CompletionObject<Response>?
    
    func getLocation(_ closure: CompletionObject<Response>? ) {
        completion = closure
        hasSentLocation = false
        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !hasSentLocation else {
            manager.stopUpdatingLocation()
            return
        }
        if let location = locations.last?.coordinate {
            completion?(.location(location))
            hasSentLocation = true
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            completion?(.denied)
        }
    }
    
    public func findLocations(with query: String, completion: @escaping(([Location])->Void)){
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(query) { (places, error) in
            guard let places = places, error == nil else {
                completion([])
                return
            }
            let models: [Location] = places.compactMap({ place in
                var name = ""
                
                if let locationName = place.name {
                    name += locationName
                }
                
                if let adminRegion = place.administrativeArea {
                    name += ", \(adminRegion)"
                }
                
                if let locality = place.locality {
                    name += ", \(locality)"
                }
                
                if let country = place.country {
                    name += ", \(country)"
                }
                
                let result = Location(
                    title: name,
                    coordinates: place.location?.coordinate
                )
                return result
            })
            completion(models)
        }
    }
    
    
    func convertLatLongToAddress(latitude:Double?, longitude:Double?, completion: @escaping (String)->Void){
        
        guard let latitude = latitude, let longitude = longitude else {
            completion("")
            return
        }
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        var address = ""
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            guard let placemark = placemarks?[0] else {return}
            placeMark = placemark
            
            // Street address
            if let street = placeMark.thoroughfare {
                
                address = street + ", "
            }
            // City
            if let city = placeMark.locality {
                
                if city != "" {
                    address = address + city + ", "
                }
            }
            // State
            if let state = placeMark.administrativeArea {
                if state != "" {
                    address = address + state
                }
            }
            // Country
            if let country = placeMark.country {
                
                address = address + " " + country
            }
            completion(address)
        })
        
    }
}

extension LocationService {
    
    enum Response {
        case denied
        case location(CLLocationCoordinate2D)
    }
}
