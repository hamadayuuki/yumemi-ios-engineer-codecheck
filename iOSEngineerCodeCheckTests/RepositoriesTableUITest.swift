//
//  RepositoriesTableUITest.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 濵田　悠樹 on 2023/02/24.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import XCTest

@testable import iOSEngineerCodeCheck

class RepositoriesTableUITest: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false  // テスト失敗時 テストを終了
        app = XCUIApplication()
        app.launch()
    }

    func test_Githubのリポジトリの表示_成功() {
        app.waitForExistence(timeout: 10.0)

        let searchFields = app.searchFields.firstMatch
        searchFields.tap()
        searchFields.typeText("Swift")  // Swift の検索結果がなくなることはないと仮定
        app.buttons["search"].tap()

        let initialItemCell = app.tables.firstMatch.children(matching: .cell).firstMatch.waitForExistence(timeout: 10)
        XCTAssertTrue(initialItemCell)
    }

    func test_Githubのリポジトリの表示_失敗() {
        app.waitForExistence(timeout: 10.0)

        let searchFields = app.searchFields.firstMatch
        searchFields.tap()
        searchFields.typeText("hamadahamadahamada")  // Swift の検索結果がなくなることはないと仮定
        app.buttons["search"].tap()

        let initialItemCell = app.tables.firstMatch.children(matching: .cell).firstMatch.waitForExistence(timeout: 5)
        XCTAssertFalse(initialItemCell)
    }
}
