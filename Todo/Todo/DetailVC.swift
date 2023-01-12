import UIKit

class DetailVC: UIViewController {
    
    var task : Task?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        setUpTask()

    }
    
    func setUpTask() {
        if let task = task {
            title = task.title
        }
    }
    
}
