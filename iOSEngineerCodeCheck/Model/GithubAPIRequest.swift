//
//  GithubAPIRequest.swift
//  iOSEngineerCodeCheck
//
//  Created by 濵田　悠樹 on 2023/02/23.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

class GithubAPIRequest {
    func fetchRepositories(searchWord: String) async throws -> [Repository] {
        let searchUrl = "https://api.github.com/search/repositories?q=\(searchWord)"
        var request = URLRequest(url: URL(string: searchUrl)!)
        request.httpMethod = "GET"
        let (data, _) = try await URLSession.shared.data(for: request)
        let repositories = try! JSONDecoder().decode(Repositories.self, from: data)
        return repositories.items
    }
}
