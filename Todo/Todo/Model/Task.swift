import Foundation

struct Task: Codable {
    let userId : Int
    let id: Int?
    let title: String
    let completed: Bool
    
    init(userId: Int, id: Int, title: String, completed: Bool) {
        self.title = title
        self.completed = completed
        self.userId = userId
        self.id = id
    }
}
