import Foundation

class Decode {
    
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
                    print(error)
                }
            }.resume()
        }
    }
    
    func decodeUsers(completion: @escaping ([User]) -> ()) {
        let urlString = "https://jsonplaceholder.typicode.com/users/"
        //let urlString = "https://dummyjson.com/todos?limit=3"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) {data, res, error in
                guard let data = data else {
                    return print("error")
                }
                let decoder = JSONDecoder()
                
                do {
                    let json = try decoder.decode([User].self, from: data)
                    //self.tasks = json
                    completion(json)
                } catch {
                    print(error)
                }
            }.resume()
        }
    }

}

