//
//  RepositoryCell.swift
//  iOSEngineerCodeCheck
//
//  Created by 濵田　悠樹 on 2023/02/26.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {
    @IBOutlet weak var iconImage: UIImageView?
    @IBOutlet weak var repositoryNameLabel: UILabel?
    @IBOutlet weak var updatedAtLabel: UILabel?
    @IBOutlet weak var repositoryInfoLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
