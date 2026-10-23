import Foundation
import SwiftUI

struct TodoItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var createdAt: Date
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}

class Store: ObservableObject {
    @Published var todos: [TodoItem] = []
    
    private let savePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("todos.json")
    
    init() {
        loadTodos()
    }
    
    func addTodo(title: String) {
        let newTodo = TodoItem(title: title)
        todos.insert(newTodo, at: 0)
        saveTodos()
    }
    
    func toggleTodo(id: UUID) {
        if let index = todos.firstIndex(where: { $0.id == id }) {
            todos[index].isCompleted.toggle()
            saveTodos()
        }
    }
    
    func deleteTodos(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
        saveTodos()
    }
    
    private func saveTodos() {
        do {
            let data = try JSONEncoder().encode(todos)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Failed to save todos: \(error.localizedDescription)")
        }
    }
    
    private func loadTodos() {
        do {
            let data = try Data(contentsOf: savePath)
            todos = try JSONDecoder().decode([TodoItem].self, from: data)
        } catch {
            // File doesn't exist yet or is corrupted - start with empty list
            todos = []
        }
    }
}