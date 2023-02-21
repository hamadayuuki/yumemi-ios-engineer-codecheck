//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!

    var repos: [Repository] = []
    var task: URLSessionTask?
    var index: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }

        if searchBarText.count != 0 {
            let searchUrl = "https://api.github.com/search/repositories?q=\(searchBarText)"
            task = URLSession.shared.dataTask(with: URL(string: searchUrl)!) { [weak self] (data, res, err) in
                guard let self = self else { return }
                guard let data = data else { return }
                let repositories = try! JSONDecoder().decode(Repositories.self, from: data)
                self.repos = repositories.items
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            task?.resume()  // リスト更新
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            let dtl: ViewController2? = segue.destination as? ViewController2
            dtl?.vc1 = self
        }
    }

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
