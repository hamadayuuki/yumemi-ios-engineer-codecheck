//
//  RequestTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 濵田　悠樹 on 2023/02/24.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import XCTest

@testable import iOSEngineerCodeCheck

@MainActor
class RequestTests: XCTestCase {
    func test_GithubAPIからリポジトリを取得_成功() {
        let expectation = expectation(description: "_GithubAPIからリポジトリを取得_成功")

        Task {
            do {
                let searchText = "swift"
                let githubAPISearchUrl = "https://api.github.com/search/repositories?q=\(searchText)"
                let data = try await Request().fetchData(url: githubAPISearchUrl)
                let repos: Repositories = try! JSONDecoder().decode(Repositories.self, from: data)

                XCTAssertFalse(repos.items.isEmpty)
                expectation.fulfill()
            }
            catch {
                XCTFail(error.localizedDescription)
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func test_GithubAPIからリポジトリを取得_失敗() {
        let expectation = expectation(description: "_GithubAPIからリポジトリを取得_失敗")

        Task {
            do {
                let searchText = "hamadahamadahamada"
                let githubAPISearchUrl = "https://api.github.com/search/repositories?q=\(searchText)"
                let data = try await Request().fetchData(url: githubAPISearchUrl)
                let repos: Repositories = try! JSONDecoder().decode(Repositories.self, from: data)

                XCTAssertTrue(repos.items.isEmpty)
                expectation.fulfill()
            }
            catch {
                XCTFail(error.localizedDescription)
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }
}
