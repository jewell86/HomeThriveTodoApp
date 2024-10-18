import XCTest

class AddItemViewUITests: XCTestCase {
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

    func test_addItemFlow() {
        // Add new item functionality
        let addItemView = app.otherElements["addItemView"]
        XCTAssertTrue(addItemView.exists)
        addItemView.tap()
        
        let alert = app.alerts["Add Todo Item"]

        let textField = app.textFields["Item details"]
        textField.tap()
        textField.typeText("It's new!")

        let okButton = alert.buttons["okButton"]
        XCTAssertTrue(okButton.exists)
        okButton.tap()
        
        // Navigate to All filter to see new item
        let allButton = app.buttons["All"]
        XCTAssertTrue(allButton.exists, "The 'All' button should exist.")
        allButton.tap()

        let newItem = app.staticTexts["It's new!"]
        XCTAssertTrue(newItem.exists)
        
        // Cancel button functionality
        addItemView.tap()

        let cancelButton = alert.buttons["cancelButton"]
        XCTAssertTrue(cancelButton.exists)
        cancelButton.tap()

        XCTAssertFalse(alert.exists)
    }
}
