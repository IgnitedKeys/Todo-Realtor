import UIKit


class TodoVC: UIViewController {
    
    var tasks : [Task]?
    var users : [User]?
    private let cellIdentifier = "cell"
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        setTableView()
        self.view = tableView
        
        parse() { (data) in
            print(data)
            self.users = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
        
    func setTableView() {
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    func parse(completion: @escaping ([User]) -> ()) {
        let urlString = "https://jsonplaceholder.typicode.com/users/"
        //let urlString = "https://dummyjson.com/todos?limit=3"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) {data, res, error in
                guard let data = data else {
                    return print("error")
                }
                let decoder = JSONDecoder()
                
                do {
                    let json = try decoder.decode([User].self, from: data)
                    //self.tasks = json
                    completion(json)
                } catch {
                    print(error)
                }
               
                
            }.resume()
        }
    }
    

}

extension TodoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserTableViewCell else {
            fatalError("Cannot dequeue \(cellIdentifier)")
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
        //detailVC.task = task
        detailVC.user = user?.id
//        navigationController?.pushViewController(detailVC, animated: true)
        show(detailVC, sender: self)
    }

}
