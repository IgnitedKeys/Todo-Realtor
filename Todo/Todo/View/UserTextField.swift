import Foundation
import UIKit

/// Custom style for text fields
class UserTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTextField() {
        self.font = UIFont.systemFont(ofSize: 20)
        self.borderStyle = UITextField.BorderStyle.roundedRect
        self.autocorrectionType = UITextAutocorrectionType.no
    }
}
