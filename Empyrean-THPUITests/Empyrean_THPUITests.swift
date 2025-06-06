//
//  Empyrean_THPUITests.swift
//  Empyrean-THPUITests
//
//  Created by Sophia Gorgonio on 6/2/25.
//

import XCTest

final class Empyrean_THP_UITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("--uitesting")
        app.launch()
    }

    func testLoginUIElementsExist() throws {
        let appTitle = app.staticTexts["appTitle"]
        XCTAssertTrue(appTitle.waitForExistence(timeout: 5), "App title not found")

        let usernameField = app.textFields["usernameField"]
        XCTAssertTrue(usernameField.waitForExistence(timeout: 5), "Username field not found")

        let passwordField = app.secureTextFields["passwordField"]
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5), "Password field not found")

        let loginButton = app.buttons["loginButton"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 5), "Login button not found")
    }

    func testLoginWithCorrectCredentials() throws {
        let usernameField = app.textFields["usernameField"]
        let passwordField = app.secureTextFields["passwordField"]
        let loginButton = app.buttons["loginButton"]

        XCTAssertTrue(usernameField.waitForExistence(timeout: 5))
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5))
        XCTAssertTrue(loginButton.waitForExistence(timeout: 5))

        usernameField.tap()
        usernameField.typeText("test")

        passwordField.tap()
        passwordField.typeText("password123")

        loginButton.tap()

        let favoritesButton = app.buttons["favoritesButton"]
        XCTAssertTrue(favoritesButton.waitForExistence(timeout: 5), "Posts screen not shown after login")
    }

    func testLoginWithInvalidCredentialsShowsError() throws {
        let usernameField = app.textFields["usernameField"]
        let passwordField = app.secureTextFields["passwordField"]
        let loginButton = app.buttons["loginButton"]

        XCTAssertTrue(usernameField.waitForExistence(timeout: 5))
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5))
        XCTAssertTrue(loginButton.waitForExistence(timeout: 5))

        usernameField.tap()
        usernameField.typeText("wrongUser")

        passwordField.tap()
        passwordField.typeText("wrongPass")

        loginButton.tap()

        let errorMessage = app.staticTexts["errorMessage"]
        XCTAssertTrue(errorMessage.waitForExistence(timeout: 5), "Expected error message not shown")
    }
}
