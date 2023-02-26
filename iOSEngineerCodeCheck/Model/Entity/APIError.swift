//
//  APIError.swift
//  iOSEngineerCodeCheck
//
//  Created by 濵田　悠樹 on 2023/02/26.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

enum APIError: Error {
    // クライアントエラー
    case badrequest  // 400
    case unauthorized  // 401
    case forbidden  // 403
    case notfound  // 404
    case validationFailed  // 422
    // サーバーエラー
    case server(Int)  // 500台
    case unknown(Int)  // 200台+上記 以外

    var _code: Int {
        switch self {
        case .badrequest:
            return 400
        case .unauthorized:
            return 401
        case .forbidden:
            return 403
        case .notfound:
            return 404
        case .validationFailed:
            return 422
        case .server(let statusCode):
            return statusCode
        case .unknown(let statusCode):
            return statusCode
        }
    }

    var title: String {
        switch self {
        case .badrequest:
            return "400 Bad Request"
        case .unauthorized:
            return "401 Unauthorized"
        case .forbidden:
            return "403 Forbidden"
        case .notfound:
            return "404 Not Found"
        case .validationFailed:
            return "422 Unprocessable Entity"
        default:
            return "サーバーエラー"
        }
    }

    var description: String {
        switch self {
        case .badrequest:
            return "クライントエラー"
        case .unauthorized:
            return "認証に関するエラー"
        case .forbidden:
            return "閲覧権限に関するエラー"
        case .notfound:
            return "ページが存在しないエラー"
        case .validationFailed:
            return "処理が行われないエラー"
        default:
            return "サーバーに関するエラー"
        }
    }

    init(statusCode: Int) {
        switch statusCode {
        case 400:
            self = .badrequest
        case 401:
            self = .unauthorized
        case 403:
            self = .forbidden
        case 404:
            self = .notfound
        case 422:
            self = .validationFailed
        case 500..<600:
            self = .server(statusCode)
        default:
            self = .unknown(statusCode)
        }
    }
}
