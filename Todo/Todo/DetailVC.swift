import UIKit

class DetailVC: UIViewController {
    
    var tasks : [Task]?
    var user: User?
    private let cellIdentifier = "cell"
    //var tableView: UITableView!
    
    lazy var userInfoView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        view.backgroundColor = .gray
        return view
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 240, width: self.view.frame.width, height: self.view.frame.height - 180))
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = user?.name
        
        self.view.addSubview(userInfoView)
        setUserInfo()
        
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        //self.view.addSubview(tableView)
        scrollView.addSubview(tableView)
        setTableView()


        parse() { (data) in
            print(data.count)
            self.tasks = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
        
    func setTableView() {
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(TableHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUserInfo() {
        let phoneLabel = UILabel(frame: CGRect(x: 10, y: 60, width: self.view.bounds.size.width, height: 100))
        phoneLabel.text = "Phone: \(user?.phone ?? "N/A")"
        phoneLabel.textAlignment = .center
        userInfoView.addSubview(phoneLabel)
        
        let emailLabel = UILabel(frame: CGRect(x: 10, y: 100, width: self.view.bounds.size.width, height: 100))
        emailLabel.text = "Email: \(user?.email ?? "N/A")"
        emailLabel.textAlignment = .center
        userInfoView.addSubview(emailLabel)
        
        let usernameLabel = UILabel(frame: CGRect(x: 10, y: 140, width: self.view.bounds.size.width, height: 100))
        usernameLabel.text = "Username: \(user?.username ?? "N/A")"
        usernameLabel.textAlignment = .center
        userInfoView.addSubview(usernameLabel)
    }

    func parse(completion: @escaping ([Task]) -> ()) {
        let urlString = "https://jsonplaceholder.typicode.com/todos?userId=\(user?.id ?? 3)"
        //let urlString = "https://dummyjson.com/todos?limit=3"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) {data, res, error in
                guard let data = data else {
                    return print("error")
                }
                let decoder = JSONDecoder()
                
                do {
                    let json = try decoder.decode([Task].self, from: data)
                    //self.tasks = json
                    completion(json)
                } catch {
                    print(error)
                }
               
                
            }.resume()
        }
    }
    


}

extension DetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TaskTableViewCell else {
            fatalError("Cannot dequeue \(cellIdentifier)")
        }
        
        cell.configure(with: tasks?[indexPath.row] ?? Task(userId: 1, id: 300, title: "Loading...", completed: false))
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 10

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        return header
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 200
//    }
  
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        let task = self.tasks?[indexPath.row]
//        let detailVC = DetailVC()
//        detailVC.task = task
////        navigationController?.pushViewController(detailVC, animated: true)
//        show(detailVC, sender: self)
//    }


// delete choosen cell, edit choosen cell, change to completed
//add new cell
}
