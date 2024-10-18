import CoreData

protocol ServiceProtocol {
    func getTodoList(for user: String) async throws -> [TodoItem]
}

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

class Service: ServiceProtocol {
    private struct Endpoints {
        static let getTodoList = "https://jsonplaceholder.typicode.com/users/%@/todos"
    }
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func getTodoList(for user: String) async throws -> [TodoItem] {
        let endpointURLString = String(format: Endpoints.getTodoList, user)
        
        guard let endpointURL = URL(string: endpointURLString) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, _) = try await session.data(from: endpointURL)
            
            let response = try JSONDecoder().decode([TodoItem].self, from: data)
            return Array(response.prefix(5))
        }
        catch {
            throw error
        }
    }
}

// MARK: Service Mock For Previews

final class MockPreviewService: ServiceProtocol {
    var items: [TodoItem]?
    
    func getTodoList(for user: String) async throws -> [TodoItem] {
        return items ?? []
    }
}
