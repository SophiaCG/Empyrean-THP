//
//  Empyrean_THPTests.swift
//  Empyrean-THPTests
//
//  Created by Sophia Gorgonio on 6/2/25.
//

import XCTest
@testable import Empyrean_THP

final class LoginViewModelTests: XCTestCase {

    var viewModel: LoginViewModel!

    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
        UserDefaults.standard.removeObject(forKey: "authToken")
    }

    func testLogin_withInvalidUsername_setsError() {
        viewModel.username = "wrong"
        viewModel.password = "password123"
        viewModel.login()

        XCTAssertTrue(viewModel.wrongUsername)
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertEqual(viewModel.errorMessage, "Invalid credentials")
    }

    func testLogin_withInvalidPassword_setsError() {
        viewModel.username = "test"
        viewModel.password = "wrong"
        viewModel.login()

        XCTAssertTrue(viewModel.wrongPassword)
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertEqual(viewModel.errorMessage, "Invalid credentials")
    }

    func testLogin_withValidCredentials_successfulLogin() {
        let expectation = self.expectation(description: "LoginSuccess")
        viewModel.username = "test"
        viewModel.password = "password123"

        viewModel.login()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.token, "fake-jwt-token")
            XCTAssertTrue(self.viewModel.isAuthenticated)
            XCTAssertEqual(UserDefaults.standard.string(forKey: "authToken"), "fake-jwt-token")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
}
