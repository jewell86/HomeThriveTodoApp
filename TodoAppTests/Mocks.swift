import CoreData

@testable import TodoApp

// MARK: Service Mock

final class MockService: ServiceProtocol {
    var items: [TodoItem]?
    
    func getTodoList(for user: String) async throws -> [TodoItem] {
        return items ?? []
    }
}

// MARK: URLSession Mock

class MockURLSession: URLSessionProtocol {
    var data: Data?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        guard let data = data else {
            throw URLError(.badServerResponse)
        }
        return (data, URLResponse())
    }
}

// MARK: CoreData Mock

class CoreDataMock {
    static let shared = CoreDataMock()

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

// MARK: Service Response Success Mock

internal func mockItemsResponse() -> Data? {
    let mockResponse = """
    [
      {
        "userId": 3,
        "id": 41,
        "title": "aliquid amet impedit consequatur aspernatur placeat eaque fugiat suscipit",
        "completed": false
      },
      {
        "userId": 3,
        "id": 42,
        "title": "rerum perferendis error quia ut eveniet",
        "completed": false
      },
      {
        "userId": 3,
        "id": 43,
        "title": "tempore ut sint quis recusandae",
        "completed": true
      },
      {
        "userId": 3,
        "id": 44,
        "title": "cum debitis quis accusamus doloremque ipsa natus sapiente omnis",
        "completed": true
      },
      {
        "userId": 3,
        "id": 45,
        "title": "velit soluta adipisci molestias reiciendis harum",
        "completed": false
      },
      {
        "userId": 3,
        "id": 46,
        "title": "vel voluptatem repellat nihil placeat corporis",
        "completed": false
      },
      {
        "userId": 3,
        "id": 47,
        "title": "nam qui rerum fugiat accusamus",
        "completed": false
      },
      {
        "userId": 3,
        "id": 48,
        "title": "sit reprehenderit omnis quia",
        "completed": false
      },
      {
        "userId": 3,
        "id": 49,
        "title": "ut necessitatibus aut maiores debitis officia blanditiis velit et",
        "completed": false
      },
      {
        "userId": 3,
        "id": 50,
        "title": "cupiditate necessitatibus ullam aut quis dolor voluptate",
        "completed": true
      },
      {
        "userId": 3,
        "id": 51,
        "title": "distinctio exercitationem ab doloribus",
        "completed": false
      },
      {
        "userId": 3,
        "id": 52,
        "title": "nesciunt dolorum quis recusandae ad pariatur ratione",
        "completed": false
      },
      {
        "userId": 3,
        "id": 53,
        "title": "qui labore est occaecati recusandae aliquid quam",
        "completed": false
      },
      {
        "userId": 3,
        "id": 54,
        "title": "quis et est ut voluptate quam dolor",
        "completed": true
      },
      {
        "userId": 3,
        "id": 55,
        "title": "voluptatum omnis minima qui occaecati provident nulla voluptatem ratione",
        "completed": true
      },
      {
        "userId": 3,
        "id": 56,
        "title": "deleniti ea temporibus enim",
        "completed": true
      },
      {
        "userId": 3,
        "id": 57,
        "title": "pariatur et magnam ea doloribus similique voluptatem rerum quia",
        "completed": false
      },
      {
        "userId": 3,
        "id": 58,
        "title": "est dicta totam qui explicabo doloribus qui dignissimos",
        "completed": false
      },
      {
        "userId": 3,
        "id": 59,
        "title": "perspiciatis velit id laborum placeat iusto et aliquam odio",
        "completed": false
      },
      {
        "userId": 3,
        "id": 60,
        "title": "et sequi qui architecto ut adipisci",
        "completed": true
      }
    ]
    """
    
    return mockResponse.data(using: .utf8)
}

// MARK: Service Response Malformed Mock

internal func mockItemsResponseFailure() -> Data? {
    let mockResponse = """
    {
        {
            "userId": 3,
            "title": "aliquid amet impedit consequatur aspernatur placeat eaque fugiat suscipit",
            "completed": false
        },
        {
            "id": 42,
            "title": "rerum perferendis error quia ut eveniet",
            "completed": false
        },
        {
            "userId": 3,
            "id": 43,
            "title": "tempore ut sint quis recusandae",
        },
        {
            "userId": 3,
            "title": "cum debitis quis accusamus doloremque ipsa natus sapiente omnis",
            "completed": true
        },
        {
            "userId": 3,
            "title": "velit soluta adipisci molestias reiciendis harum",
            "completed": false
        },
        {
            "userId": 3,
            "id": 46,
            "title": "vel voluptatem repellat nihil placeat corporis",
            "completed": false
        },
        {
            "userId": 3,
            "id": 47,
            "title": "nam qui rerum fugiat accusamus",
            "completed": false
        },
        {
            "userId": ,
            "id": 48,
            "title": "sit reprehenderit omnis quia",
            "completed": false
        },
        {
            "userId": 3,
            "id": 49,
            "title": ,
            "completed": false
        },
        {
            "userId": 3,
            "id": 50,
            "title": "cupiditate necessitatibus ullam aut quis dolor voluptate",
            "completed":
        },
        {
            "userId": 3,
            "id": 51,
            "title": "distinctio exercitationem ab doloribus",
            "completed": false
        },
        {
            "userId": 3,
            "id": 52,
            "title": "nesciunt dolorum quis recusandae ad pariatur ratione",
            "completed": false
        },
        {
            "userId": 3,
            "id": 53,
            "title": "qui labore est occaecati recusandae aliquid quam",
            "completed": false
        },
        {
            "userId": 3,
            "id": 54,
            "title": "quis et est ut voluptate quam dolor",
            "completed": true
        },
        {
            "userId": 3,
            "id": 55,
            "title": "voluptatum omnis minima qui occaecati provident nulla voluptatem ratione",
            "completed": true
        },
        {
            "userId": 3,
            "id": 56,
            "title": "deleniti ea temporibus enim",
            "completed": true
        },
        {
            "userId": 3,
            "id": 57,
            "title": "pariatur et magnam ea doloribus similique voluptatem rerum quia",
            "completed": false
        },
        {
            "userId": 3,
            "id": 58,
            "title": "est dicta totam qui explicabo doloribus qui dignissimos",
            "completed": false
        },
        {
            "userId": 3,
            "id": 59,
            "title": "perspiciatis velit id laborum placeat iusto et aliquam odio",
            "completed": false
        },
        {
            "userId": 3,
            "id": 60,
            "title": "et sequi qui architecto ut adipisci",
            "completed": true
        }
    }
    """
    
    return mockResponse.data(using: .utf8)
}
