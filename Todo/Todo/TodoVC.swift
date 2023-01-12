import UIKit


class TodoVC: UIViewController {
    
    private var tasks : [Task]?
    private let cellIdentifier = "cell"
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        setTableView()
        self.view = tableView
        
        parse() { (data) in
            print(data.count)
            self.tasks = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func loadView() {
        tableView = UITableView()
        self.view = tableView
        parse() {
            data in
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
        //set constraints!

//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func parse(completion: @escaping ([Task]) -> ()) {
        let urlString = "https://jsonplaceholder.typicode.com/todos/"
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

extension TodoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TaskTableViewCell else {
            fatalError("Cannot dequeue \(cellIdentifier)")
        }
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TaskTableViewCell {
//            cell.textLabel?.text = tasks?[indexPath.row].title
//            return cell
//        }
//        fatalError("no cell to dequeue")
        cell.configure(with: tasks?[indexPath.row] ?? Task(userId: 1, id: 300, title: "Loading...", completed: false))
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 10

    }
}
