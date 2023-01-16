import UIKit


class UsersVC: UIViewController {
    
    var tasks : [Task]?
    var users : [User]?
    let decoder = Decode()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Team Members"
        
        view.backgroundColor = .secondarySystemBackground
        self.view.addSubview(tableView)
        setTableView()
        
        decoder.decodeUsers() { (data) in
            print(data)
            self.users = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
        
    func setTableView() {
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let leadingConstraint = tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        let topConstraint = tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20)
        let bottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        view.addConstraints([horizontalConstraint, verticalConstraint, leadingConstraint, topConstraint, bottomConstraint])
    }
}

extension UsersVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell else {
            fatalError("Cannot dequeue \(UserTableViewCell.identifier)")
        }
        
        cell.configure(with: users?[indexPath.row] ?? User(id: 1, name: "Loading...", username: "", email: "", phone: ""))
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 10

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let user = self.users?[indexPath.row]
        let detailVC = DetailVC()
        detailVC.user = user
        show(detailVC, sender: self)
    }

}
