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
    @Published var apiErrorAlart: APIErrorAlart = APIErrorAlart(title: "", description: "")
    @Published var isLoading = false

    public func setRepositories(searchText: String) async throws {
        let githubAPISearchUrl = "https://api.github.com/search/repositories?q=\(searchText)"
        isLoading = true
        do {
            let result = try await self.request.fetchData(url: githubAPISearchUrl)
            self.isLoading = false
            switch result {
            case let .success(data):
                let repos: Repositories = try! JSONDecoder().decode(Repositories.self, from: data)  // TODO: 変数名変更, Repositoriesの命名から変更
                self.repositories = repos.items
            case let .failure(apiError):
                self.apiErrorAlart = APIErrorAlart(title: apiError.title, description: apiError.description)
            }
        } catch (let error) {
            print(error.localizedDescription)
            self.isLoading = false
        }
    }

    public func addRepositories(searchText: String, page: Int) async throws {
        guard !isLoading else { return }  // 連続でAPIを叩かないように
        let githubAPISearchUrl = "https://api.github.com/search/repositories?q=\(searchText)&page=\(2)"
        isLoading = true
        do {
            let result = try await self.request.fetchData(url: githubAPISearchUrl)
            self.isLoading = false
            switch result {
            case let .success(data):
                let repos: Repositories = try! JSONDecoder().decode(Repositories.self, from: data)  // TODO: 変数名変更, Repositoriesの命名から変更
                self.repositories += repos.items
            case let .failure(apiError):
                self.apiErrorAlart = APIErrorAlart(title: apiError.title, description: apiError.description)
            }
        } catch (let error) {
            print(error.localizedDescription)
            self.isLoading = false
        }
    }
}
