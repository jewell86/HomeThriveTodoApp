import XCTest

class ListViewUITests: XCTestCase {
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

    func test_toggleItem() {
        // Setup new Not Completed item
        itemSetup()
        
        // Toggle button tap
        let toggleButton = app.buttons["toggleButton"]
        XCTAssertTrue(toggleButton.exists)
        XCTAssertFalse(toggleButton.isSelected)
        toggleButton.tap()

        // Navigate to Completed filter
        let completedButton = app.buttons["Completed"]
        XCTAssertTrue(completedButton.exists)
        completedButton.tap()
        
        // Verify item is now in completed section
        let newItem = app.staticTexts["Its an item"]
        XCTAssertTrue(newItem.exists)
        XCTAssertTrue(toggleButton.isSelected)
    }

    func test_deleteItem() {
        // Setup new Not Completed item
        itemSetup()
        
        // Verify item list
        let itemList = app.collectionViews["listView"]
        XCTAssertTrue(itemList.exists)
        
        let firstCell = itemList.cells.firstMatch
        XCTAssertTrue(firstCell.exists)
        
        // Delete functionality
        firstCell.swipeLeft()
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.exists)
        deleteButton.tap()

        XCTAssertFalse(firstCell.exists)
    }
    
    private func itemSetup() {
        // Add new item
        let addItemView = app.otherElements["addItemView"]
        XCTAssertTrue(addItemView.exists)
        addItemView.tap()
        
        let alert = app.alerts["Add Todo Item"]

        let textField = app.textFields["Item details"]
        textField.tap()
        textField.typeText("Its an item")

        let okButton = alert.buttons["okButton"]
        XCTAssertTrue(okButton.exists)
        okButton.tap()

        // Navigate to NotCompleted filter to see new item
        let notCompletedButton = app.buttons["Not Completed"]
        XCTAssertTrue(notCompletedButton.exists)
        notCompletedButton.tap()
    }
}
