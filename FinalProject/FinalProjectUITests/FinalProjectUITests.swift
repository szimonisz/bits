//
//  FinalProjectUITests.swift
//  FinalProjectUITests
//
//  Created by Kelemen Szimonisz on 11/12/17.
//  Copyright © 2017 Kelemen Szimonisz. All rights reserved.
//

import XCTest

class FinalProjectUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCategoryPopulation(){
        
        let app = XCUIApplication()
        let originalCategoryCellCount = app.tables.cells.count

        app.navigationBars["Categories"].buttons["+"].tap()
        
        let enterACategoryNameTextField = app.textFields["Enter a Category Name"]
        enterACategoryNameTextField.tap()
        enterACategoryNameTextField.typeText("UITESTCATEGORY")
        app.buttons["Create Category"].tap()
        app.navigationBars["Create Category"].buttons["Categories"].tap()
        
        XCTAssertTrue(app.tables.cells.count - originalCategoryCellCount == 1,"Category table did not populate after creation of new category")
      

        app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["UITESTCATEGORY"].tap()
        
    
   
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
