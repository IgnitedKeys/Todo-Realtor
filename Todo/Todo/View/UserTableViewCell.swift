import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let identifier = "userCell"

    func configure(with user: User) {
        textLabel?.text = user.name

    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
