//
//  RepositoriesTableViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Combine
import UIKit

class RepositoriesTableViewController: UITableViewController {
    private let repositoriesTableModel = RepositoriesTableModel()

    @IBOutlet private weak var searchBar: UISearchBar!

    private var cancellable = Set<AnyCancellable>()
    var repos: [Repository] = []
    var index: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        setLayout()
        setBinding()
    }

    private func setLayout() {
        searchBar.text = "GitHubのリポジトリを検索できるよー"
    }

    private func setBinding() {
        repositoriesTableModel.$repositories
            .receive(on: DispatchQueue.main)  // .sink{ }内で DispatchQueue.main.async を実行するようなもの
            .sink { [weak self] repositories in
                guard let self = self else { return }
                self.repos = repositories
                self.tableView.reloadData()
            }
            .store(in: &cancellable)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            let dtl: RepositoryDetailViewController? = segue.destination as? RepositoryDetailViewController
            dtl?.vc1 = self
        }
    }
}

// MARK: SearchBarDelegate

extension RepositoriesTableViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }

        if !searchBarText.isEmpty {
            Task {
                try await repositoriesTableModel.fetchGithubRepositories(searchText: searchBarText)
            }
        }
    }
}

// MARK: TableViewDelegate

extension RepositoriesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count  // Default 30, https://docs.github.com/ja/rest/search?apiVersion=2022-11-28#search-repositories
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell") ?? UITableViewCell()
        let repo = repos[indexPath.row]
        cell.textLabel?.text = repo.full_name
        cell.detailTextLabel?.text = repo.language
        cell.tag = indexPath.row
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}