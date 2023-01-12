import UIKit

class DetailVC: UIViewController {
    
    var tasks : [Task]?
    var user: User?
    private let cellIdentifier = "cell"
    //var tableView: UITableView!
    
    lazy var userInfoView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400))
        view.backgroundColor = .gray
        return view
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 400, width: self.view.frame.width, height: self.view.frame.height))
        //setTableView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = user?.name
        
        self.view.addSubview(userInfoView)
        self.view.addSubview(tableView)
        
//        tableView = UITableView()
        setTableView()
        //self.view = tableView
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
        tableView.delegate = self
        tableView.dataSource = self
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
