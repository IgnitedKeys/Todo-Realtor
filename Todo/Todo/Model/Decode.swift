import Foundation

class Decode {
    
    /// Use JSONDecoder to get all user tasks
    /// - Parameters:
    ///   - filename: API path with the userId to get all user tasks
    ///   - completion: Array of user's decoded Task objects
    func decodeTasks(url filename: String, completion: @escaping ([Task]) -> ()) {
        let urlString = filename
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
                    print("Error converting data into json object\n \(error)")
                }
            }.resume()
        }
    }
    
    /// User JSONDecoder to get all users
    /// - Parameter completion: Array of all User Objects
    func decodeUsers(completion: @escaping ([User]) -> ()) {
        let urlString = "https://jsonplaceholder.typicode.com/users/"
        //let urlString = "https://dummyjson.com/todos?limit=3"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) {data, res, error in
                guard let data = data else {
                    return print("No data")
                }
                let decoder = JSONDecoder()
                
                do {
                    let json = try decoder.decode([User].self, from: data)
                    completion(json)
                } catch {
                    print("Error converting data into json object\n \(error)")
                }
            }.resume()
        }
    }
    
}

