import SwiftUI

struct ListView: View {
    @EnvironmentObject private var viewModel: ViewModel
    @Binding var isPresentingAddItemView: Bool
    @Binding var todoItemDescription: String
    @Binding var itemToEdit: TodoItemEntity?
    
    var body: some View {
        List {
            ForEach($viewModel.filteredTodoItems) { $item in
                HStack {
                    Button(action: {
                        viewModel.receive(event: .toggleItem(item: item))
                    }) {
                        Image(systemName: item.completed ? "checkmark.square" : "square")
                            .foregroundColor(item.completed ? .green : .gray)
                    }
                    .accessibility(identifier: "toggleButton")

                    Text(item.title ?? "")
                        .strikethrough(item.completed)
                        .foregroundColor(item.completed ? .gray : .black)
                        .accessibility(identifier: "itemTitle")

                    Spacer()

                    Button(action: {
                        itemToEdit = item
                        isPresentingAddItemView.toggle()
                    }) {
                        Image(systemName: "pencil")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibility(identifier: "editButton")
                }
            }
            .onDelete(perform: deleteItem)
        }
        .accessibility(identifier: "itemList")
    }
    
    private func deleteItem(at offsets: IndexSet) {
        withAnimation {
            viewModel.receive(event: .deleteItem(at: offsets))
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataPreviewMock().persistentContainer.viewContext
        let viewModel = ViewModel(service: MockPreviewService(), viewContext: context)
        
        let exampleItem1 = TodoItemEntity(context: context)
        exampleItem1.title = "Sample Todo Item 1"
        exampleItem1.completed = false
        exampleItem1.userId = 3
        exampleItem1.id = 1
        
        let exampleItem2 = TodoItemEntity(context: context)
        exampleItem2.title = "Sample Todo Item 2"
        exampleItem2.completed = true
        exampleItem2.userId = 3
        exampleItem2.id = 2
        
        viewModel.todoItems = [exampleItem1, exampleItem2]
        
        return ListView(isPresentingAddItemView: .constant(false),
                        todoItemDescription: .constant(""),
                        itemToEdit: .constant(nil))
        .environmentObject(viewModel)
    }
}
