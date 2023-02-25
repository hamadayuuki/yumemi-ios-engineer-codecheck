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

    public var cancellable = Set<AnyCancellable>()
    public var repository: Repository!

    // sotoryboardとの接続を忘れていない限りnilが入ることはない
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var repoTitleLabel: UILabel!
    @IBOutlet private weak var repoLanguageLabel: UILabel!
    @IBOutlet private weak var starLabel: UILabel!
    @IBOutlet private weak var wachLabel: UILabel!
    @IBOutlet private weak var forkLabel: UILabel!
    @IBOutlet private weak var issueLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        setBinding()
        getImage()
    }

    private func setBinding() {
        repositoryDetailViewModel.$avatarUIImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] avatarUIImage in
                guard let self = self else { return }
                self.avatarImageView.image = avatarUIImage
            }
            .store(in: &cancellable)
    }

    private func setLayout() {
        let shareButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareRepository(_:)))
        self.navigationItem.rightBarButtonItem = shareButton

        repoTitleLabel.text = repository.full_name
        repoLanguageLabel.text = "✏️ : \(repository.language ?? "")"
        starLabel.text = "⭐️ : \(repository.stargazers_count)"
        wachLabel.text = "👀 : \(repository.watchers_count)"
        forkLabel.text = "🔀 : \(repository.forks_count)"
        issueLabel.text = "❗️ : \(repository.open_issues_count)"
    }

    func getImage() {
        let owner = repository.owner
        if !owner.avatar_url.isEmpty {
            let imageUrl = owner.avatar_url
            Task {
                do {
                    try await repositoryDetailViewModel.setAvatarUIImage(url: imageUrl)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

    // MARK: Button Action

    @objc func shareRepository(_ sender: UIBarButtonItem) {
        print("共有ボタンが押されました")
        let shareItems = [repository.full_name, UIImage(named: "github-mark"), URL(string: repository.html_url)!] as [Any]
        let shareActivityView = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        self.present(shareActivityView, animated: true)
    }
}
