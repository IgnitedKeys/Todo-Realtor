import UIKit


class TodoVC: UIViewController {
    
    var tasks : [Task]?
    var users : [User]?
    var tableView: UITableView!
    let decoder = Decode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        setTableView()
        self.view = tableView
        
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
    }
}

extension TodoVC: UITableViewDelegate, UITableViewDataSource {
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
//        navigationController?.pushViewController(detailVC, animated: true)
        show(detailVC, sender: self)
    }

}
