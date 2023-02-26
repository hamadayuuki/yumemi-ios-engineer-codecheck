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
    func test_GithubAPIからリポジトリを取得_検索結果が複数返ってくる() {
        let expectation = expectation(description: "_GithubAPIからリポジトリを取得_検索結果が複数返ってくる")

        Task {
            let searchText = "swift"
            let githubAPISearchUrl = "https://api.github.com/search/repositories?q=\(searchText)"
            let result = try await Request().fetchData(url: githubAPISearchUrl)
            switch result {
            case let .success(data):
                let repos: Repositories = try! JSONDecoder().decode(Repositories.self, from: data)
                XCTAssertFalse(repos.items.isEmpty)
                expectation.fulfill()
            case let .failure(apiError):
                XCTFail("APIError: \(apiError.title)")
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func test_GithubAPIからリポジトリを取得_検索結果が空で返ってくる() {
        let expectation = expectation(description: "_GithubAPIからリポジトリを取得_検索結果が空で返ってくる")

        Task {
            let searchText = "hamadahamadahamada"
            let githubAPISearchUrl = "https://api.github.com/search/repositories?q=\(searchText)"
            let result = try await Request().fetchData(url: githubAPISearchUrl)
            switch result {
            case let .success(data):
                let repos: Repositories = try! JSONDecoder().decode(Repositories.self, from: data)
                XCTAssertTrue(repos.items.isEmpty)
                expectation.fulfill()
            case let .failure(apiError):
                XCTFail("APIError: \(apiError.title)")
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }
}
