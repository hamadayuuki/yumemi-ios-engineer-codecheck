//
//  RepositoriesViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Combine
import UIKit

class RepositoryDetailViewController: UIViewController {
    let repositoryDetailViewModel = RepositoryDetailViewModel()

    var cancellable = Set<AnyCancellable>()
    public var repositories: [Repository]?

    // sotoryboardとの接続を忘れていない限りnilが入ることはない
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var repoTitleLabel: UILabel!
    @IBOutlet private weak var repoLanguageLabel: UILabel!
    @IBOutlet private weak var starLabel: UILabel!
    @IBOutlet private weak var wachLabel: UILabel!
    @IBOutlet private weak var forkLabel: UILabel!
    @IBOutlet private weak var issueLabel: UILabel!

    weak public var repositoriesTableViewController: RepositoriesTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let repositoriesTableViewController = repositoriesTableViewController else { return }
        guard let index = repositoriesTableViewController.index else { return }
        let repository = repositoriesTableViewController.repositories[index]

        setLayout(repo: repository)
        getImage(repo: repository)

        repositoryDetailViewModel.$avatarUIImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] avatarUIImage in
                guard let self = self else { return }
                self.avatarImageView.image = avatarUIImage
            }
            .store(in: &cancellable)
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
            let imageUrl = owner.avatar_url
            Task {
                try await repositoryDetailViewModel.setAvatarUIImage(url: imageUrl)
            }
        }
    }
}
