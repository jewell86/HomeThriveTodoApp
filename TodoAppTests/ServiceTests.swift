import XCTest

@testable import TodoApp

class ServiceTests: XCTestCase {
    var subject: Service!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        
        mockURLSession = MockURLSession()
        subject = Service(session: mockURLSession)
    }
    
    override func tearDown() {
        subject = nil
        mockURLSession = nil
        
        super.tearDown()
    }
    
    func test_getTodoListSuccess() async throws {
        // Given
        let response = mockItemsResponse()
        mockURLSession.data = response
        
        // When
        do {
            let items = try await subject.getTodoList(for: "3")
            
            // Then
            XCTAssertEqual(items.count, 5)
            XCTAssertEqual(items[0].title, "aliquid amet impedit consequatur aspernatur placeat eaque fugiat suscipit")
            XCTAssertEqual(items[1].title, "rerum perferendis error quia ut eveniet")
            XCTAssertEqual(items[2].title, "tempore ut sint quis recusandae")
        } catch {
            XCTFail("Test failed: \(error)")
        }
    }
    
    func test_getTodoListFailure() async throws {
        // Given
        let response = mockItemsResponseFailure()
        mockURLSession.data = response
        
        // When
        do {
            let _ = try await subject.getTodoList(for: "3")
            XCTFail("Test failed")
        } catch {
            // Then
            XCTAssertNotNil(error)
        }
    }
}
