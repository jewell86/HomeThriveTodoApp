internal struct TodoItem: Codable, Equatable, Identifiable {
    let userId: Int
    let id: Int
    var title: String
    var completed: Bool
}
