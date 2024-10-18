import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: ViewModel
    @State private var isPresentingAddItemView = false
    @State private var todoItemDescription: String = ""
    @State private var itemToEdit: TodoItemEntity?

    var body: some View {
        NavigationView {
            VStack {
                FilterView()
                    .environmentObject(viewModel)
                    .accessibility(identifier: "filterView")
                ListView(isPresentingAddItemView: $isPresentingAddItemView,
                                         todoItemDescription: $todoItemDescription,
                                         itemToEdit: $itemToEdit)
                                    .environmentObject(viewModel)
                                    .accessibility(identifier: "listView")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    AddItemView()
                        .environmentObject(viewModel)
                        .accessibility(identifier: "addItemView")
                }
            }
            .onAppear {
                getTodoList(userId: "3")
            }
            .sheet(item: $itemToEdit) { item in
                EditItemView(item: item)
                    .environmentObject(viewModel)
                    .accessibility(identifier: "editItemView")
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }

    private func getTodoList(userId: String) {
        viewModel.receive(event: .getItems(userId: userId))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataPreviewMock.shared.persistentContainer.viewContext
        let viewModel = ViewModel(service: MockPreviewService(), viewContext: context)
        
        let exampleItem1 = TodoItemEntity(context: context)
        exampleItem1.title = "Item 1"
        exampleItem1.completed = false
        exampleItem1.userId = 1
        exampleItem1.id = 1
        
        let exampleItem2 = TodoItemEntity(context: context)
        exampleItem2.title = "Item 2"
        exampleItem2.completed = true
        exampleItem2.userId = 2
        exampleItem2.id = 2
        
        viewModel.todoItems = [exampleItem1, exampleItem2]
        
        return ContentView()
            .environmentObject(viewModel)
    }
}
