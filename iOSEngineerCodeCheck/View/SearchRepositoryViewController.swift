//
//  SearchRepositoryViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Combine
import Loaf
import Nuke
import UIKit

class SearchRepositoryViewController: UIViewController {
    private let repositoriesTableViewModel = RepositoriesTableViewModel()

    @IBOutlet var repositoriesTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    private var activityIndicatorView: UIActivityIndicatorView!

    private var cancellable = Set<AnyCancellable>()
    var repositories: [Repository] = []
    var index: Int?
    private let nukeOptions = ImageLoadingOptions(placeholder: UIImage(named: "github-mark"), transition: .fadeIn(duration: 0.2))

    override func viewDidLoad() {
        super.viewDidLoad()
        repositoriesTableView.dataSource = self
        repositoriesTableView.delegate = self
        repositoriesTableView.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: "RepositoryCell")

        searchBar.delegate = self

        setLayout()
        setBinding()
    }

    private func setLayout() {
        self.title = "リポジトリ検索"

        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = .large
        activityIndicatorView.layer.position = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        view.addSubview(activityIndicatorView)
    }

    private func setBinding() {
        repositoriesTableViewModel.$repositories
            .receive(on: DispatchQueue.main)  // .sink{ }内で DispatchQueue.main.async を実行するようなもの
            .sink { [weak self] repositories in
                guard let self = self else { return }
                self.repositories = repositories  // TODO: レスポンスを正常に受け取ったが、中身が空の時アラート表示
                self.repositoriesTableView.reloadData()
            }
            .store(in: &cancellable)

        repositoriesTableViewModel.$apiErrorAlart
            .receive(on: DispatchQueue.main)
            .sink { [weak self] apiErrorAlart in
                guard let self = self else { return }
                if !apiErrorAlart.title.isEmpty && !apiErrorAlart.description.isEmpty {
                    // エラー表示
                    Loaf(apiErrorAlart.description, state: .custom(.init(backgroundColor: .systemPink, width: .screenPercentage(0.8))), location: .top, sender: self).show(.short) { dismissalType in
                        switch dismissalType {
                        case .tapped:
                            print("Tapped!")
                        case .timedOut:
                            print("Timmed out!")
                        }
                    }
                }
            }
            .store(in: &cancellable)
    }
}

// MARK: SearchBarDelegate

extension SearchRepositoryViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }

        if !searchBarText.trimmingCharacters(in: .whitespaces).isEmpty {
            Task {
                activityIndicatorView.startAnimating()
                do {
                    try await repositoriesTableViewModel.setRepositories(searchText: searchBarText)
                    activityIndicatorView.stopAnimating()
                } catch {
                    print(error.localizedDescription)
                    activityIndicatorView.stopAnimating()
                }
            }
        }
    }
}

// MARK: TableViewDelegate

extension SearchRepositoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count  // Default 30, https://docs.github.com/ja/rest/search?apiVersion=2022-11-28#search-repositories
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as! RepositoryCell
        let repo = repositories[indexPath.row]
        let avatarImageUrl = URL(string: repo.owner.avatar_url)!
        Nuke.loadImage(with: avatarImageUrl, options: nukeOptions, into: cell.iconImage!)
        cell.repositoryNameLabel?.text = repo.full_name
        cell.updatedAtLabel?.text = "last: \(repo.updated_at.prefix(10).replacingOccurrences(of:"-", with:"/"))"  // "2013-01-05T17:58:47Z" -> "2013-01-05" -> "2013/01/05"
        cell.repositoryInfoLabel?.text = "⭐️\(repo.stargazers_count)   👀\(repo.watchers_count)"
        cell.tag = indexPath.row
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row

        // 画面遷移
        let storyboard: UIStoryboard = UIStoryboard(name: "RepositoryDetail", bundle: nil)
        let nextVC = storyboard.instantiateViewController(identifier: "RepositoryDetail") as! RepositoryDetailViewController
        nextVC.repository = repositories[index!]  // nil にならない. nilになるときはTableが表示されていない
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
