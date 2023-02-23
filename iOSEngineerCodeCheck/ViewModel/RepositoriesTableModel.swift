//
//  ViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 濵田　悠樹 on 2023/02/23.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Combine

class ViewModel: ObservableObject {
    private let githubRequest = GithubAPIRequest()

    @Published var repositories: [Repository] = []

    public func fetchGithubRepositories(searchText: String) async throws {
        repositories = try await githubRequest.fetchRepositories(searchWord: searchText)
    }
}
