

import UIKit
import SideMenu

class HomeController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var menu: SideMenuNavigationController?
    
    private let userManager = UserManager()
    
    private let manager = RequestManager()
    private var requests: [ObjectRequest] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    fileprivate let cellIdentifier = "RequestCell"
    
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
        
        manager.currentRequests { (requests) in
            let filtered = requests.filter { request in
                return !(request.isCompleted ?? false)
            }
            if self.requests.count < filtered.count && self.requests.count > 0{
                Alerts.showAlert(on: self, title: "Update", message: "There's a new request, are you intrested?")
            }
            self.requests = filtered
        }
        
        
        userManager.userData(for: UserDefaults.userId) { (user) in
            if let user = user {
                if user.token != UserDefaults.fcmToken{
                    user.token = UserDefaults.fcmToken
                    self.userManager.update(user: user) { (response) in
                        switch response {
                        case .failure:Alerts.showAlert(on: self, title: "Error", message: "token not updated")
                        case .success:
                            print("token updated")
                        }
                    }
                }
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
    
    @IBAction func requestButtonTapped(){
        let controller = SelectLocationController()
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
    
}

extension HomeController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.restore()
        tableView.separatorStyle = .none
        if requests.count == 0{
            tableView.setEmptyView(title: "No Requests", message: "There are no current requests", imageName: "face.smiling.fill")
        }
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RequestCell
        cell.request = requests[indexPath.row]
        return cell
    }
    
}

// MARK:- UITableViewDelegate
extension HomeController: UITableViewDelegate{
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
