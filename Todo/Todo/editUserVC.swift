import UIKit

class editUserVC: UIViewController, UITextFieldDelegate {
    
    var user : User?
    var editedUserInfo : User?
    
    var phone: String?
 

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        //form with user data
        //button to send data to API
        //button also dismisses the view
        
        let userPhone = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 300))
        userPhone.placeholder = user?.phone ?? "123-456-7890"
        userPhone.delegate = self
        self.view.addSubview(userPhone)
        
        //let phone = "12345"
        editedUserInfo = User(id: user?.id ?? 200, name: user!.name ?? "N/A", username: user?.username ?? "", email: user?.email ?? "", phone: userPhone.text ?? "555-555-5555")
 
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 50, y: 50, width: 100, height: 50)
        button.setTitle("edit user", for: .normal)
        button.addTarget(self, action: #selector(editUser), for: .touchUpInside)
        view.addSubview(button)
        
    }
        
    
    @objc func editUser() {
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
        editedUserInfo = User(id: user?.id ?? 200, name: user!.name ?? "N/A", username: user?.username ?? "", email: user?.email ?? "", phone: textField.text ?? "1234")
        return true
    }
    
    }

    


