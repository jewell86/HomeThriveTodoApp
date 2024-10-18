import SwiftUI

@main
struct TodoApp: App {
    @StateObject var viewModel = ViewModel(
        service: TodoApp.makeService(),
        viewContext: CoreDataController.shared.container.viewContext
    )

    static func makeService() -> Service {
        let session = URLSession.shared
        return Service(session: session)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
