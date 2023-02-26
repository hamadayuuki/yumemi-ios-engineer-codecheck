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
    @IBOutlet private weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.contentMode = .scaleAspectFit
            avatarImageView.layer.cornerRadius = 24
        }
    }
    @IBOutlet private weak var repoTitleLabel: UILabel!
    @IBOutlet private weak var updatedAtLabel: UILabel!
    @IBOutlet private weak var repositoryInfoLabel: UILabel!

    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var shareImage: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var showWebLabel: UILabel!
    @IBOutlet weak var showWebImage: UIImageView!
    @IBOutlet weak var showWebButton: UIButton!

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
        repoTitleLabel.text = repository.full_name
        updatedAtLabel.text = "updatedAt: \( repository.updated_at.prefix(10).replacingOccurrences(of: "-", with: "/"))"
        repositoryInfoLabel.text = "⭐️ \(repository.stargazers_count.convertEnglishUtil())    👀 \(repository.watchers_count.convertEnglishUtil())    🔀 \(repository.forks_count.convertEnglishUtil())   ❗️ \(repository.open_issues_count.convertEnglishUtil())"

        shareLabel.text = "シェア"
        shareImage.image = UIImage(systemName: "square.and.arrow.up")
        shareButton.addTarget(self, action: #selector(shareRepository(_:)), for: .touchUpInside)
        showWebLabel.text = "WEB"
        showWebImage.image = UIImage(systemName: "globe.badge.chevron.backward")
        showWebButton.addTarget(self, action: #selector(showWebView(_:)), for: .touchUpInside)
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
        let shareItems = [repository.full_name, UIImage(named: "github-mark")!, URL(string: repository.html_url)!] as [Any]
        let shareActivityView = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        self.present(shareActivityView, animated: true)
    }

    @objc func showWebView(_ sender: UIBarButtonItem) {
        let webUIViewController = WebUIViewContorller(url: repository.html_url, barTitle: repository.full_name)
        let webNavigationController = UINavigationController(rootViewController: webUIViewController)  // 遷移先画面で NavigationBar を表示させるため
        self.present(webNavigationController, animated: true)
    }
}
