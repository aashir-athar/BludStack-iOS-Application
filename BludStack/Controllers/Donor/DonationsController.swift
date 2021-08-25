

import UIKit

class DonationsController: UIViewController {
    
    // MARK:- Variables
    private var tableView: UITableView = UITableView()
    private let manager = RequestManager()
    private var requests: [ObjectRequest] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    fileprivate let cellIdentifier = "RequestCell"
    

    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func loadView() {
        super.loadView()
        setUpView()
    }
    
}

// MARK:- BaseViewDelegate
extension DonationsController{
    func setUpView() {
        view.backgroundColor = .white
        navigationItem.title = "Donations"
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        setUpTableView()
    }
    
    func setUpTableView() {
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        tableView.fillSuperview()
        
        manager.currentDonations { (requests) in
            
            self.requests = requests
        }
    }
    
}

// MARK:- UITableViewDataSource
extension DonationsController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RequestCell
        cell.request = requests[indexPath.row]
        return cell
    }
}

// MARK:- UITableViewDelegate
extension DonationsController: UITableViewDelegate{
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
