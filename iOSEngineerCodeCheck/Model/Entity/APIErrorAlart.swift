//
//  APIErrorAlart.swift
//  iOSEngineerCodeCheck
//
//  Created by 濵田　悠樹 on 2023/02/26.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

struct APIErrorAlart {
    var title: String
    var description: String

    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}
