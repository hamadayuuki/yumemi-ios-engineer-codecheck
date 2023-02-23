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

    public func setAvatarUIImage(url: String) async throws {
        let data = try await request.fetchData(url: url)
        avatarUIImage = UIImage(data: data) ?? UIImage()
    }
}
