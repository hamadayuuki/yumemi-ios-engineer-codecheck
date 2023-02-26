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

        getImage()
        setLayout()
        setBinding()
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

    private func setLayout() {
        let shareButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareRepository(_:)))
        let showWebButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(showWebView(_:)))
        self.navigationItem.rightBarButtonItems = [showWebButton, shareButton]

        repoTitleLabel.text = repository.full_name
        repoLanguageLabel.text = "✏️ : \(repository.language ?? "")"
        starLabel.text = "⭐️ : \(repository.stargazers_count)"
        wachLabel.text = "👀 : \(repository.watchers_count)"
        forkLabel.text = "🔀 : \(repository.forks_count)"
        issueLabel.text = "❗️ : \(repository.open_issues_count)"
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

    // MARK: Button Action

    @objc func shareRepository(_ sender: UIBarButtonItem) {
        let shareItems = [repository.full_name, UIImage(named: "github-mark"), URL(string: repository.html_url)!] as [Any]
        let shareActivityView = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        self.present(shareActivityView, animated: true)
    }

    @objc func showWebView(_ sender: UIBarButtonItem) {
        let webUIViewController = WebUIViewContorller(url: repository.html_url, barTitle: repository.full_name)
        let webNavigationController = UINavigationController(rootViewController: webUIViewController)  // 遷移先画面で NavigationBar を表示させるため
        self.present(webNavigationController, animated: true)
    }
}
