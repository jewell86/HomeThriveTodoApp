import CoreData

class CoreDataController {
    static let shared = CoreDataController()

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoItemEntity")

        if CommandLine.arguments.contains("--uitesting") {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
}

// MARK: CoreData Mock For Previews

class CoreDataPreviewMock {
    static let shared = CoreDataPreviewMock()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoItemEntity")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { (description, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func reset() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TodoItemEntity.fetchRequest()

        do {
            let results = try viewContext.fetch(fetchRequest) as! [NSManagedObject]
            for result in results {
                viewContext.delete(result)
            }
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
