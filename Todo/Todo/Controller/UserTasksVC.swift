import UIKit

class UserTasksVC: UIViewController {
    
    var tasks : [Task]?
    var user: User?
    let decoder = Decode()
    
    lazy var userInfoView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 280))
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 280, width: self.view.frame.width, height: self.view.frame.height - 300))
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = user?.name
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editUser))
        
        self.view.addSubview(userInfoView)
        setUserInfo()
        
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        setScrollView(scrollView)

        scrollView.addSubview(tableView)
        setTableView()
        
        decoder.decodeTasks(url: "https://jsonplaceholder.typicode.com/todos?userId=\(user?.id ?? 3)" ) { (data) in
                        self.tasks = data
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
            
                            let completedTasksLabel = UILabel(frame: CGRect(x: 10, y: 180, width: self.view.bounds.size.width, height: 100))
                            completedTasksLabel.text = "Completed Tasks: \(self.calculateTasks()) / \(self.tasks?.count ?? 0)"
                            completedTasksLabel.textAlignment = .center
                            self.userInfoView.addSubview(completedTasksLabel)
                        }
                    }
    }
        
    func setScrollView(_ scrollView: UIScrollView){
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setTableView() {
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.register(TableHeader.self, forHeaderFooterViewReuseIdentifier: "TableHeader")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUserInfo() {
        let usernameLabel = UILabel(frame: CGRect(x: 10, y: 60, width: self.view.bounds.size.width, height: 100))
        usernameLabel.text = "Username: \(user?.username ?? "N/A")"
        usernameLabel.textAlignment = .center
        userInfoView.addSubview(usernameLabel)
        
        let phoneLabel = UILabel(frame: CGRect(x: 10, y: 100, width: self.view.bounds.size.width, height: 100))
        phoneLabel.text = "Phone: \(user?.phone ?? "N/A")"
        phoneLabel.textAlignment = .center
        userInfoView.addSubview(phoneLabel)
        
        let emailLabel = UILabel(frame: CGRect(x: 10, y: 140, width: self.view.bounds.size.width, height: 100))
        emailLabel.text = "Email: \(user?.email ?? "N/A")"
        emailLabel.textAlignment = .center
        userInfoView.addSubview(emailLabel)
        

        
        if tasks?.count != nil {
            let completeLabel = UILabel(frame: CGRect(x: 10, y: 180, width: self.view.bounds.size.width, height: 100))
            completeLabel.text = "\(tasks?.count)"
            completeLabel.textAlignment = .center
            userInfoView.addSubview(completeLabel)
        }
    }
    
    func calculateTasks() -> Int {
        let filtered = tasks?.filter { task in
            return task.completed == true
        }
        return filtered?.count ?? 0
    }
    
    @objc func editUser() {
        let editUserVC = editUserVC()
        editUserVC.user = user
        present(editUserVC, animated: true)
    }
}

extension UserTasksVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else {
            fatalError("Cannot dequeue \(TaskTableViewCell.identifier)")
        }
        
        cell.configure(with: tasks?[indexPath.row] ?? Task(userId: 1, id: 300, title: "Loading...", completed: false))
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 10

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeader.identifier)
        return header
    }
}
