import UIKit

class editUserVC: UIViewController, UITextFieldDelegate {
    
    var user : User?
    var editedUserInfo : User?
    var phone : String?
    var username : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        //form with user data
        //button to send data to API
        //button also dismisses the view
        
        let userPhone = UITextField(frame: CGRect(x: 20, y: 20, width: 300, height: 300))
        userPhone.becomeFirstResponder()
        userPhone.placeholder = user?.phone ?? "123-456-7890"
        userPhone.delegate = self
        self.view.addSubview(userPhone)
        phone = userPhone.text
        
        let userUsername = UITextField(frame: CGRect(x: 20, y: 40, width: 300, height: 300))
        userUsername.becomeFirstResponder()
        userUsername.placeholder = user?.username ?? "N/A"
        userUsername.delegate = self
        username = userUsername.text
        self.view.addSubview(userUsername)
        
//        editedUserInfo = User(id: user?.id ?? 200, name: user!.name ?? "N/A", username: username ?? "cute", email: user?.email ?? "", phone: phone ?? "555-555-5555")
 
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 50, y: 50, width: 100, height: 50)
        button.setTitle("edit user", for: .normal)
        button.addTarget(self, action: #selector(editUser), for: .touchUpInside)
        view.addSubview(button)
        
    }
        
    
    @objc func editUser() {
        editedUserInfo = User(id: user?.id ?? 200, name: user!.name ?? "N/A", username: username ?? "cute", email: user?.email ?? "", phone: phone ?? "555-555-5555")
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //phone = textField.text ?? "1234"
        self.resignFirstResponder()
        
        
//        editedUserInfo = User(id: user?.id ?? 200, name: user!.name ?? "N/A", username: username ?? "", email: user?.email ?? "", phone: phone ?? "1234")
        return false
    }
    
    }

    


