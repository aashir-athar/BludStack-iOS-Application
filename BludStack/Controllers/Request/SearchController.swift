

import UIKit
import CoreLocation
import GooglePlaces

protocol SearchControllerDelegate: AnyObject {
    func searchController(_ vc: SearchController, didSelectLocationWith coordinates: CLLocationCoordinate2D?)
}

class SearchController: UIViewController {
    
    weak var delegate: SearchControllerDelegate?
    let locationService = LocationService()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Where?"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private let field: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter destination"
        field.layer.cornerRadius = 9
        field.backgroundColor = .primaryColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        return field
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "location"), for: .normal)
        return button
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var locations: [Location] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(label)
        view.addSubview(field)
        view.addSubview(button)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        field.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tap))
        button.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: 10, y: 10, width: label.frame.size.width, height: label.frame.size.height)
        
        field.frame = CGRect(x: 10, y: 20+label.frame.size.height, width: view.frame.size.width-20, height: 50)
        button.frame = CGRect(x: view.frame.size.width-60, y: 25+label.frame.size.height, width: 40, height: 40)
        
        let tableY: CGFloat = field.frame.origin.y+field.frame.size.height+5
        tableView.frame = CGRect(x: 0, y: tableY, width: view.frame.size.width, height: view.frame.size.height-tableY)
    }
    
    @objc func tap() {
        locationService.getLocation {[weak self] response in
            switch response {
            case .denied:
                self?.showAlert(title: "Error", message: "Please enable location services")
            case .location(let location):
                guard let self = self else {return}
                self.delegate?.searchController(self, didSelectLocationWith: location)
            }
        }
    }
    
}

extension SearchController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        field.resignFirstResponder()
        if let text = field.text, !text.isEmpty{
            
            locationService.findLocations(with: text) { [weak self] (locations) in
                DispatchQueue.main.async {
                    self?.locations = locations
                    self?.tableView.reloadData()
                }
            }
        }
        return true
    }
}

extension SearchController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = locations[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.searchController(self, didSelectLocationWith: locations[indexPath.row].coordinates)
    }
    
}
