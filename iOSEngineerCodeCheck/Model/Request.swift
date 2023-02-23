//
//  Request.swift
//  iOSEngineerCodeCheck
//
//  Created by 濵田　悠樹 on 2023/02/23.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

class Request {
    func fetchData(url: String) async throws -> Data {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
