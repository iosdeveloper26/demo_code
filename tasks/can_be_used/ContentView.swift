import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @State private var newTodoText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Input section
                HStack {
                    TextField("Enter new todo", text: $newTodoText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: addTodo) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)
                    .disabled(newTodoText.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(.vertical)
                
                // Todo list
                List {
                    ForEach(store.todos) { todo in
                        TodoRow(todo: todo)
                    }
                    .onDelete(perform: deleteTodos)
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("My Todo List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
    
    private func addTodo() {
        let trimmedText = newTodoText.trimmingCharacters(in: .whitespaces)
        guard !trimmedText.isEmpty else { return }
        
        store.addTodo(title: trimmedText)
        newTodoText = ""
    }
    
    private func deleteTodos(at offsets: IndexSet) {
        store.deleteTodos(at: offsets)
    }
}

struct TodoRow: View {
    @EnvironmentObject var store: Store
    let todo: TodoItem
    
    var body: some View {
        HStack {
            Button(action: {
                store.toggleTodo(id: todo.id)
            }) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(todo.isCompleted ? .green : .gray)
                    .font(.title3)
            }
            .buttonStyle(PlainButtonStyle())
            
            Text(todo.title)
                .strikethrough(todo.isCompleted)
                .foregroundColor(todo.isCompleted ? .gray : .primary)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Store())
    }
}