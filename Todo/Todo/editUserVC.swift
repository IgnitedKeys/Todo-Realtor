import UIKit

class editUserVC: UIViewController {
    
    var user : User?
    var editedUserInfo : User?
    var phone : String?
    var username : String?
    var email: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        let nameLabel = UILabel(frame: CGRect(x: 10, y: 10, width: self.view.bounds.size.width, height: 100))
        nameLabel.text = "Editing \(user?.name ?? "N/A")"
        nameLabel.textAlignment = .center
        view.addSubview(nameLabel)
        
        let userUsername = UITextField(frame: CGRect(x: 10, y: 100, width: self.view.bounds.size.width, height: 40))

        userUsername.placeholder = user?.username ?? "myUsername"
        userUsername.accessibilityLabel = "userUsername"
        userUsername.delegate = self
        self.view.addSubview(userUsername)

        
        let userPhone = UITextField(frame: CGRect(x: 10, y: 150, width: self.view.bounds.size.width - 20, height: 40))

        userPhone.placeholder = user?.phone ?? "555-555-5555"
        userPhone.accessibilityLabel = "userPhone"
        userPhone.font = UIFont.systemFont(ofSize: 20)
        userPhone.borderStyle = UITextField.BorderStyle.roundedRect
        userPhone.autocorrectionType = UITextAutocorrectionType.no
        userPhone.keyboardType = UIKeyboardType.default
        userPhone.returnKeyType = UIReturnKeyType.done
        userPhone.delegate = self
        self.view.addSubview(userPhone)
        //phone = userPhone.text
        
        let userEmail = UITextField(frame: CGRect(x: 10, y: 200 , width: self.view.bounds.size.width, height: 40))
        userEmail.placeholder = user?.email ?? "example.@example.com"
        userEmail.accessibilityLabel = "userEmail"
        userEmail.delegate = self
        self.view.addSubview(userEmail)
    
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 50, y: 50, width: 100, height: 50)
        button.setTitle("edit user", for: .normal)
        button.addTarget(self, action: #selector(editUser), for: .touchUpInside)
        view.addSubview(button)
        
    }
        
    
    @objc func editUser() {
        editedUserInfo = User(id: user?.id ?? 200, name: user?.name ?? "N/A", username: (username ?? user?.username) ?? "N/A" , email: (email ?? user?.email) ?? "N/A", phone: (phone ?? user?.phone) ?? "N/A")
 
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(user!.id)") else {
                    print("Error no URL")
                    return
                }
        
        guard let jsonData = try? JSONEncoder().encode(editedUserInfo) else {
                    print("Error when encoding")
                    return
                }
        var request = URLRequest(url: url)
                request.httpMethod = "PUT"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard error == nil else {
                        print("error calling PUT")
                        print(error!)
                        return
                    }
                    guard let data = data else {
                        print("No data")
                        return
                    }
                    
                    do {
                        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                            print("Failed converting data to JSON object")
                            return
                        }
                        guard let prettyPrintedJson = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                            print("Failed converting JSON object to prettyPrinted")
                            return
                        }
                        guard let jsonString = String(data: prettyPrintedJson, encoding: .utf8) else {
                            print("Failed converting JSON into String")
                            return
                        }

                        print(jsonString)
                    } catch {
                        print("Error: Failed turning JSON into String")
                        return
                    }
                }.resume()
        self.dismiss(animated: true, completion: nil)
            }
}

extension editUserVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        self.resignFirstResponder()
        if textField.accessibilityLabel == "userPhone" {
            phone = textField.text
        } else if textField.accessibilityLabel == "userUsername" {
            username = textField.text
        } else if textField.accessibilityLabel == "userEmail" {
            email = textField.text
        }
        return true
    }
}

    


