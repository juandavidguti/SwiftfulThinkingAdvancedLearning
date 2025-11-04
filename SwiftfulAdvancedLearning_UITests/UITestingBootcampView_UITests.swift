//
//  UITestingBootcampView_UITests.swift
//  SwiftfulAdvancedLearning_UITests
//
//  Created by Juan David Gutierrez Olarte on 2/11/25.
//

import XCTest

// Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
// Naming Structure: test_[struct]_[ui component]_[expected result]
// Testing Structure: Given, When, Then


final class UITestingBootcampView_UITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
//        app.launchArguments = ["-UITest_startSignedIn"]
//        app.launchEnvironment = ["-UITest_startSignIn2" : "true"]
        app.launch()
    }
    
    override func tearDownWithError() throws {
        
    }
    
    // MARK: - TESTS
    
    // edge case of navbar does not exists so the xctassert false would be fulfill, aka the test succeeds
    func test_UITestingBootcampView_signUpButton_shouldNotSignIn() {
        
        // Given
        _ = enterName("")
        dismissKeyboardIfPresent()

        // When
        tapSignUp()
        let navBar = app.staticTexts["Welcome"].firstMatch

        // Then
        XCTAssertFalse(navBar.exists)
    }
    
    func test_UITestingBootcampView_signUpButton_shouldSignIn() {
        
        // Given
        signUpAndSignIn(shouldTypeOnKeyboard: true)

        // Then
        let navBar = app.staticTexts["Welcome"].firstMatch
        XCTAssertTrue(navBar.exists)
        
    }
    
    
    func test_UITestingBootcampView_showAlertButton_shouldDisplayAlert() {
        
        // Given
        signUpAndSignIn(shouldTypeOnKeyboard: false)
        let welcomeNavBar = app.staticTexts["Welcome"].firstMatch
        XCTAssertTrue(welcomeNavBar.waitForExistence(timeout: 2), "Welcome screen should be visible after sign in")

        // When
        tapAlertButton(shouldDismissAlert: false)

        // Then
        let okButton = app.buttons["OK"].firstMatch
        XCTAssertTrue(okButton.waitForExistence(timeout: 2), "OK button should appear in alert")
    }
    func test_UITestingBootcampView_showAlertButton_shouldDisplayAndDismissAlert() {
        
        // Given
        signUpAndSignIn(shouldTypeOnKeyboard: false)

        // When
        tapAlertButton(shouldDismissAlert: true)

        // Then
        let alertExists = app.alerts.firstMatch.waitForExistence(timeout: 5)
        XCTAssertFalse(alertExists)
       
    }
    
    func test_UITestingBootcampView_navigationLinkToDestination_shouldNavigateToDestination() {
        
        // Given
        signUpAndSignIn(shouldTypeOnKeyboard: true)

        // When
        navigateToDestinationAndBack(shouldGoBack: false)
    }
    
    func test_UITestingBootcampView_navigationLinkToDestination_shouldNavigateToDestinationAndGoBack() {
        
        // Given
        signUpAndSignIn(shouldTypeOnKeyboard: true)

        // When
        navigateToDestinationAndBack(shouldGoBack: true)
    }
    
//    func test_UITestingBootcampView_navigationLinkToDestination_shouldNavigateToDestinationAndGoBack2() {
//        
//        // Given
//        // we dont need to go for the whole sign in flow, so we pass the arguments and run this test and should start signed in already.
//        // When
//        navigateToDestinationAndBack(shouldGoBack: true)
//    }
}

// MARK: FUNCTIONS
extension UITestingBootcampView_UITests {
    @discardableResult
    func enterName(_ name: String, file: StaticString = #file, line: UInt = #line) -> XCUIElement {
        let textField = app.textFields["SignUpTextField"].firstMatch
        XCTAssertTrue(textField.waitForExistence(timeout: 2), "Name text field should exist", file: file, line: line)
        textField.tap()
        if name.isEmpty == false {
            textField.typeText(name)
        }
        return textField
    }

    func typeOnKeyboard(_ text: String) {
        for ch in text { app.keys[String(ch)].firstMatch.tap() }
    }

    func dismissKeyboardIfPresent() {
        let returnButton = app.buttons["Return"].firstMatch
        if returnButton.exists { returnButton.tap() }
    }

    @discardableResult
    func tapSignUp(file: StaticString = #file, line: UInt = #line) -> XCUIElement {
        let signUpButton = app.buttons["SignUpButton"].firstMatch
        XCTAssertTrue(signUpButton.waitForExistence(timeout: 2), "Sign up button should exist", file: file, line: line)
        signUpButton.tap()
        return signUpButton
    }

    func signUpAndSignIn(shouldTypeOnKeyboard: Bool) {
        if shouldTypeOnKeyboard {
            let _ = enterName("")
            typeOnKeyboard("Aa")
        } else {
            let _ = enterName("Aa")
        }
        dismissKeyboardIfPresent()
        tapSignUp()
    }

    func tapAlertButton(shouldDismissAlert: Bool) {
        let showAlertButtonByText = app.buttons["Show welcome alert!"].firstMatch
        let showAlertButtonById = app.buttons["ShowAlertButton"].firstMatch
        let button = showAlertButtonById.exists ? showAlertButtonById : showAlertButtonByText
        XCTAssertTrue(button.waitForExistence(timeout: 2), "Show alert button should exist")
        button.tap()
        if shouldDismissAlert {
            let ok = app.buttons["OK"].firstMatch
            XCTAssertTrue(ok.waitForExistence(timeout: 2), "OK button should appear in alert")
            ok.tap()
        }
    }

    func waitForWelcomeIfNeeded() {
        let welcome = app.staticTexts["Welcome"].firstMatch
        _ = welcome.waitForExistence(timeout: 2)
    }

    func navigateToDestinationAndBack(shouldGoBack: Bool) {
        let navigateButton = app.buttons["NavigationLinkForDestination"].firstMatch
        XCTAssertTrue(navigateButton.waitForExistence(timeout: 2), "Navigate button should exist")
        navigateButton.tap()
        let destinationTitle = app.staticTexts["Destination"].firstMatch
        XCTAssertTrue(destinationTitle.waitForExistence(timeout: 2), "Destination screen should be visible")
        if shouldGoBack {
            let backButton = app.buttons["BackButton"].firstMatch
            XCTAssertTrue(backButton.waitForExistence(timeout: 2), "Back button should exist on Destination screen")
            backButton.tap()
        }
    }
}
