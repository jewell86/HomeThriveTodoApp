import Combine
import CoreData
import Foundation

// MARK: Enums

internal enum FilterType: String, CaseIterable {
    case all = "All"
    case completed = "Completed"
    case notCompleted = "Not Completed"
}

internal enum ViewEvent: Equatable {
    case getItems(userId: String)
    case deleteItem(at: IndexSet)
    case toggleItem(item: TodoItemEntity)
    case addItem(title: String)
    case updateItem(item: TodoItemEntity, title: String)
}

// MARK: ViewModel

internal class ViewModel: ObservableObject {
    
    // MARK: Private properties
    
    internal var viewContext: NSManagedObjectContext
    internal let service: ServiceProtocol
    
    // MARK: Published proerties
    
    @Published var todoItems: [TodoItemEntity] = [] {
        didSet {
            applyFilter()
        }
    }
    
    @Published var currentFilter: FilterType = .completed {
        didSet {
            applyFilter()
        }
    }
    
    @Published var filteredTodoItems: [TodoItemEntity] = []
    @Published var selectedItem: TodoItemEntity?
    
    
    // MARK: Initializer
    
    internal init(
        service: ServiceProtocol,
        viewContext: NSManagedObjectContext
    ) {
        self.service = service
        self.viewContext = viewContext
    }

    // MARK: Public methods
    
    @MainActor
    public func receive(event: ViewEvent) {
        switch event {
        case .getItems(let userId):
            getItems(userId: userId)
        case .deleteItem(let index):
            deleteItem(at: index)
        case .toggleItem(let item):
            toggleItem(item: item)
        case .addItem(let title):
            addItem(title: title)
        case .updateItem(let item, let title):
            updateItem(item: item, title: title)
        }
    }

    // MARK: View event methods
    
    @MainActor
    private func getItems(userId: String) {
        if !UserDefaults.standard.bool(forKey: "isCoreDataInitialized") {
            Task {
                do {
                    let response = try await service.getTodoList(for: userId)
                    initializeCoreData(response: response)
                } catch {
                    print(error)
                }
            }
        }
        else {
            refreshList()
        }
    }
    
    @MainActor
    private func deleteItem(at offsets: IndexSet) {
        for offset in offsets {
            if offset < filteredTodoItems.count {
                let item = filteredTodoItems[offset]
                if let indexInTodoItems = todoItems.firstIndex(of: item) {
                    viewContext.delete(todoItems[indexInTodoItems])
                    todoItems.remove(at: indexInTodoItems)
                }
            }
        }
        saveList()
    }
    
    @MainActor
    private func toggleItem(item: TodoItemEntity) {
        item.completed.toggle()
        
        saveList()
    }
    
    @MainActor
    private func addItem(title: String) {
        let newItem = TodoItemEntity(context: viewContext)
        newItem.title = title
        newItem.completed = false
        newItem.userId = 3
        newItem.id = Int64.random(in: 1000...9999)

        saveList()
    }
    
    @MainActor
    private func updateItem(item: TodoItemEntity, title: String) {
        item.title = title
        
        saveList()
    }
    
    // MARK: Private methods
    
    @MainActor
    private func initializeCoreData(response: [TodoItem]) {
        clearCoreData()
        
        let dataItems = response.map { item in
            let entity = TodoItemEntity(context: viewContext)
            entity.userId = Int64(item.userId)
            entity.id = Int64(item.id)
            entity.title = item.title
            entity.completed = item.completed
            return entity
        }
        
        self.todoItems = dataItems
        
        saveList()
        UserDefaults.standard.set(true, forKey: "isCoreDataInitialized")
    }
    
    @MainActor
    private func saveList() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                refreshList()
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor
    private func refreshList() {
        let request: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
        
        do {
            let coreDataItems = try viewContext.fetch(request)
            self.todoItems = coreDataItems
        } catch {
            print(error)
        }
    }
    
    private func clearCoreData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TodoItemEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeCount
        
        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func applyFilter() {
        switch currentFilter {
        case .all:
            filteredTodoItems = todoItems
        case .completed:
            filteredTodoItems = todoItems.filter { $0.completed }
        case .notCompleted:
            filteredTodoItems = todoItems.filter { !$0.completed }
        }
    }
}
