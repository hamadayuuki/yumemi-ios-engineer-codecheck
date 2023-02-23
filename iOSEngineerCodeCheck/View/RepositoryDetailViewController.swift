//
//  RepositoriesViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryDetailViewController: UIViewController {

    // sotoryboardとの接続を忘れていない限りnilが入ることはない
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var repoTitleLabel: UILabel!
    @IBOutlet private weak var repoLanguageLabel: UILabel!
    @IBOutlet private weak var starLabel: UILabel!
    @IBOutlet private weak var wachLabel: UILabel!
    @IBOutlet private weak var forkLabel: UILabel!
    @IBOutlet private weak var issueLabel: UILabel!

    weak public var vc1: RepositoriesTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let vc1 = vc1 else { return }
        guard let index = vc1.index else { return }
        let repo = vc1.repos[index]

        setLayout(repo: repo)
        getImage(repo: repo)
    }

    private func setLayout(repo: Repository) {
        repoLanguageLabel.text = "✏️ : \(repo.language ?? "")"
        starLabel.text = "⭐️ : \(repo.stargazers_count)"
        wachLabel.text = "👀 : \(repo.watchers_count)"
        forkLabel.text = "🔀 : \(repo.forks_count)"
        issueLabel.text = "❗️ : \(repo.open_issues_count)"
    }

    func getImage(repo: Repository) {
        repoTitleLabel.text = repo.full_name

        let owner = repo.owner
        if !owner.avatar_url.isEmpty {
            let imgURL = owner.avatar_url
            URLSession.shared.dataTask(with: URL(string: imgURL)!) { [weak self] (data, res, err) in
                guard let self = self else { return }
                guard let data = data else { return }
                let img = UIImage(data: data)
                DispatchQueue.main.async {
                    self.avatarImageView.image = img
                }
            }.resume()
        }
    }
}