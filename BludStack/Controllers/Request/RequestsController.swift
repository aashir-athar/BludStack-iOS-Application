

import UIKit

class RequestsController: UIViewController {
    
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
extension RequestsController{
    func setUpView() {
        view.backgroundColor = .white
        navigationItem.title = "Requests"
        
        setUpTableView()
        setUpNavigationBar()
    }
    
    func setUpTableView() {
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        tableView.fillSuperview()
        
        manager.currentRequests { (requests) in
            
            self.requests = requests
        }
    }
    
    func setUpNavigationBar() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let addRequestButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(addRequestButtonTapped))
        self.navigationItem.rightBarButtonItem  = addRequestButton
        
    }
    
    @objc func addRequestButtonTapped () {
        let controller = SelectLocationController()
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
    
}


// MARK:- UISearchResultsUpdating
extension RequestsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        print(searchBar.text ?? "")
    }
}

// MARK:- UITableViewDataSource
extension RequestsController: UITableViewDataSource{
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
extension RequestsController: UITableViewDelegate{
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
