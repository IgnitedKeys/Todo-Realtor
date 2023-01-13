import UIKit

class TaskTableViewCell: UITableViewCell {
    
    static let identifier = "TaskCell"
    
    func configure(with task: Task) {
        textLabel?.text = task.title
        if task.completed == true {
            let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 17, weight: .medium, scale: .large)
            imageView?.image = UIImage(systemName: "multiply.circle.fill", withConfiguration: imageConfiguration)
        } else {
            let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 17, weight: .medium, scale: .large)
            imageView?.image = UIImage(systemName: "multiply.circle", withConfiguration: imageConfiguration)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
