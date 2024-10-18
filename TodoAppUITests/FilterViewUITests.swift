import XCTest

class FilterViewUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
                
        try super.tearDownWithError()
    }
    
    func test_filterView() {
        let allButton = app.buttons["All"]
        XCTAssertTrue(allButton.exists)
        allButton.tap()
        XCTAssertTrue(allButton.isSelected)
        
        let completedButton = app.buttons["Completed"]
        XCTAssertTrue(completedButton.exists)
        completedButton.tap()
        XCTAssertTrue(completedButton.isSelected)
        
        let notCompletedButton = app.buttons["Not Completed"]
        XCTAssertTrue(notCompletedButton.exists)
        notCompletedButton.tap()
        XCTAssertTrue(notCompletedButton.isSelected)
    }
}
