import XCTest

@testable import TodoApp

class ViewModelTests: XCTestCase {
    var subject: ViewModel!
    var mockService: MockService!
    var coreDataMock: CoreDataMock!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        coreDataMock = CoreDataMock.shared
        mockService = MockService()
        subject = ViewModel(service: mockService, viewContext: coreDataMock.viewContext)
        
        coreDataMock.reset()
    }

    override func tearDownWithError() throws {
        subject = nil
        mockService = nil
        coreDataMock = nil
        
        try super.tearDownWithError()
    }

    func test_addItem() async throws {
        // When
        await subject.receive(event: .addItem(title: "Test Item"))
        
        // Then
        XCTAssertEqual(subject.todoItems.count, 1)
        XCTAssertEqual(subject.todoItems.first?.title, "Test Item")
    }

    func test_deleteItem() async throws {
        // Given
        await subject.receive(event: .addItem(title: "Test Item"))

        // When
        await subject.receive(event: .deleteItem(at: IndexSet(integer: 0)))

        // Then
        XCTAssertEqual(subject.todoItems.count, 1)
    }
    
    func test_toggleItem() async throws {
        // Given
        await subject.receive(event: .addItem(title: "Test Item"))
        let item = subject.todoItems.first!
        
        // When
        await subject.receive(event: .toggleItem(item: item))
        
        // Then
        XCTAssertTrue(subject.todoItems.first!.completed)
    }

    func test_updateItem() async throws {
        // Given
        await subject.receive(event: .addItem(title: "Test Item"))
        
        // When
        let item = subject.todoItems.first!
        await subject.receive(event: .updateItem(item: item, title: "Updated Item"))
        
        // Then
        XCTAssertEqual(subject.todoItems.first!.title, "Updated Item")
    }
}
