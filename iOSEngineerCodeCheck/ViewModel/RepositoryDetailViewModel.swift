//
//  RepositoryDetailViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 濵田　悠樹 on 2023/02/23.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Combine
import UIKit

class RepositoryDetailViewModel: ObservableObject {
    private let request = Request()

    @Published public var avatarUIImage = UIImage()
    @Published var apiErrorAlart: APIErrorAlart = APIErrorAlart(title: "", description: "")

    public func setAvatarUIImage(url: String) async throws {
        let result = try await request.fetchData(url: url)
        switch result {
        case let .success(data):
            avatarUIImage = UIImage(data: data) ?? UIImage()
        case let .failure(apiError):
            apiErrorAlart.title = apiError.title
            apiErrorAlart.description = apiError.description
        }
    }
}
