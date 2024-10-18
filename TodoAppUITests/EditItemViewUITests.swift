import XCTest

class EditItemModalUITests: XCTestCase {
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

    func test_editItemFlow() {
        // Add item to be edited
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
        
        
        let allButton = app.buttons["All"]
        XCTAssertTrue(allButton.exists, "The 'All' button should exist.")
        allButton.tap()
        
        // Open edit view
        let editButton = app.buttons["editButton"].firstMatch
        XCTAssertTrue(editButton.exists)
        editButton.tap()

        let editTextField = app.textFields["itemDetailsTextField"]
        XCTAssertTrue(editTextField.exists)

        editTextField.tap()
        editTextField.typeText(" Edited")

        // Update item's title
        let editOkButton = app.buttons["okButton"]
        XCTAssertTrue(editOkButton.exists)
        editOkButton.tap()

        let editedItem = app.staticTexts["It's new! Edited"]
        XCTAssertTrue(editedItem.exists)
        XCTAssertFalse(app.navigationBars["Edit Todo Item"].exists)
        
        // Cancel button functionality
        editButton.tap()
        
        let cancelButton = app.buttons["cancelButton"]
        XCTAssertTrue(cancelButton.exists)
        cancelButton.tap()

        XCTAssertFalse(app.navigationBars["Edit Todo Item"].exists)
    }
}
