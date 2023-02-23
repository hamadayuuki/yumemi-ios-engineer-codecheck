//
//  RepositoriesTableViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 濵田　悠樹 on 2023/02/23.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Combine
import Foundation

class RepositoriesTableViewModel: ObservableObject {
    private let request = Request()

    @Published var repositories: [Repository] = []

    public func setRepositories(searchText: String) async throws {
        let githubAPISearchUrl = "https://api.github.com/search/repositories?q=\(searchText)"
        let data = try await request.fetchData(url: githubAPISearchUrl)
        let repos: Repositories = try! JSONDecoder().decode(Repositories.self, from: data)  // TODO: 変数名変更, Repositoriesの命名から変更
        repositories = repos.items
    }
}
