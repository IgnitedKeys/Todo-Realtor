//
//  UserTextField.swift
//  Todo
//
//  Created by Gavin's Old Mac on 1/16/23.
//

import Foundation
import UIKit

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
