//
//  Int+Extension.swift
//  iOSEngineerCodeCheck
//
//  Created by 濵田　悠樹 on 2023/02/26.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

extension Int {
    func convertEnglishUtil() -> String {
        let num = self
        var returnStr = String(num)
        let units = [1_000_000_000, 1_000_000_000, 1_000]
        let strUnits = ["B", "M", "K"]
        for i in 0..<3 {
            if num >= units[i] {
                returnStr = String(ceil(Double(num / units[i]))) + strUnits[i]  // 314159 -> 314K
                break
            }
        }
        return returnStr
    }
}
