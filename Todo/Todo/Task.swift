import Foundation

struct Task: Codable {
    var userId : Int
    var id: Int?
    var title: String
    var completed: Bool
    
    init(userId: Int, id: Int, title: String, completed: Bool) {
        self.title = title
        self.completed = completed
        self.userId = userId
        self.id = id
    }
}
