//
//  Find_Your_StrengthUITests.swift
//  Find Your StrengthUITests
//
//  Created by 郭坤 on 15/11/11.
//  Copyright © 2015年 Lambda Theory. All rights reserved.
//

import XCTest
@testable import Find_Your_Strength
import Parse

class Find_Your_StrengthUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        PFUser.logOut()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSurvey() {
        let app = XCUIApplication()
        
        if app.buttons["Logout"].exists {
            app.buttons["Logout"].tap()
        }
        
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("test")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("1234")
        app.buttons["Log In"].tap()
        app.buttons["Start Survey"].tap()
        app.buttons["Yes"].tap()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    
}
