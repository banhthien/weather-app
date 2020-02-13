import Foundation

struct Location: Codable, Equatable {
    var name: String = ""
    var locID: Int
    var avatar: String = ""
    var isSelected: Bool = false
    init(name: String, locID: Int, avatar: String, isSelected: Bool) {
        self.name = name
        self.locID = locID
        self.avatar = avatar
        self.isSelected = isSelected
    }
}
