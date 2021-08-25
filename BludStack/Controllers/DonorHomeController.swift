

import UIKit
import SideMenu

class DonorHomeController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cureentRequestButton: UIButton!
    
    var menu: SideMenuNavigationController?
    private var user: ObjectUser? = nil {
        didSet{
            if requests.count < 1{
                fetchRequests()
            }
        }
    }
    private let userManager = UserManager()
    private let manager = RequestManager()
    private var requests: [ObjectRequest] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    fileprivate let cellIdentifier = "RequestCell"
    
    fileprivate var request: ObjectRequest? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        
        let controller = self.storyboard?.instantiateViewController(identifier: "MenuController") as! MenuController
        menu = SideMenuNavigationController(rootViewController: controller)
        menu?.leftSide = true
        menu?.blurEffectStyle = .extraLight
        menu?.menuWidth = min(280, view.frame.height)
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        fetchRequests()
        
//        userManager.userData(for: UserDefaults.userId) { (user) in
//            if let user = user {
//                if user.token != UserDefaults.fcmToken{
//                    user.token = UserDefaults.fcmToken
//                    self.userManager.update(user: user) { (response) in
//                        switch response {
//                        case .failure:Alerts.showAlert(on: self, title: "Error", message: "token not updated")
//                        case .success:
//                            print("token updated")
//                        }
//                    }
//                }
//            }
//        }
    }
    
    func fetchRequests() {
        manager.allRequests { (requests) in
            var filtered = requests.filter { request in
                return !(request.isCompleted ?? false)
            }
            filtered = filtered.filter { request in
                let city = (request.city ?? "").lowercased()
                print("Request city: ", city, ", User city: ",UserDefaults.city)
                
                return city.contains(UserDefaults.city.lowercased())
            }
            
            filtered = filtered.filter { request in
                return (request.bloodGroup ?? "") == UserDefaults.bloodGroup
            }
            
            filtered = filtered.filter { request in
                return (request.userId != UserDefaults.userId)
            }
            let index = filtered.firstIndex{ $0.donorId == UserDefaults.userId }
            self.request = nil
//            self.cureentRequestButton.blink(enabled: false)
            if let found = index{
                self.request = filtered[found]
//                self.cureentRequestButton.blink()
            }
            
            self.cureentRequestButton.isHidden = self.request == nil
            filtered = filtered.filter { request in
                return (request.donorId ?? "") == ""
            }
            
            let lastDonation = self.user?.lastDonation ?? 0
            if ( Date().millisecondsSince1970 - lastDonation) > 7889400000{
                self.requests = filtered
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func menuButtonTapped(){
        present(menu!, animated: true)
    }
    @IBAction func cureentRequestButtonTapped(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RequestDetailController") as! RequestDetailController
        viewController.requestId = request?.id
        self.present(viewController, animated: true)
    }
    
}

extension DonorHomeController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.restore()
        tableView.separatorStyle = .none
        if request != nil{
            tableView.setEmptyView(title: "Thank You!", message: "You have are already accepted a request", imageName: "hand.thumbsup.fill")
            return 0
        }else if requests.count == 0{
            tableView.setEmptyView(title: "No Requests", message: UserDefaults.city == "" ? "Please update your location in user settings" : "There are no current requests", imageName: "face.smiling.fill")
            return requests.count
        }else{
            return requests.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RequestCell
//        cell.user = followers[indexPath.row]
        cell.request = requests[indexPath.row]
        return cell
    }
    
}

// MARK:- UITableViewDelegate
extension DonorHomeController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RequestDetailController") as! RequestDetailController
        viewController.requestId = requests[indexPath.row].id
        self.present(viewController, animated: true)
        
    }
    
}
