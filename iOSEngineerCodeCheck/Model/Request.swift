//
//  Request.swift
//  iOSEngineerCodeCheck
//
//  Created by 濵田　悠樹 on 2023/02/23.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

class Request {
    func fetchData(url: String) async throws -> Result<Data, APIError> {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        let (data, response) = try await URLSession.shared.data(for: request)
        // エラーハンドリング
        if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 400:
                return .failure(.badrequest)
            case 401:
                return .failure(.unauthorized)
            case 403:
                return .failure(.forbidden)
            case 404:
                return .failure(.notfound)
            case 422:
                return .failure(.validationFailed)
            case 500..<600:
                return .failure(.server(response.statusCode))
            default:
                break
            }
        }
        return .success(data)
    }
}
