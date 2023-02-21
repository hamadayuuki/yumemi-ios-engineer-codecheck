//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    // sotoryboardとの接続を忘れていない限りnilが入ることはない
    @IBOutlet weak var avatarImageView: UIImageView!

    @IBOutlet weak var repoTitleLabel: UILabel!
    @IBOutlet weak var repoLanguageLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var wachLabel: UILabel!
    @IBOutlet weak var forkLabel: UILabel!
    @IBOutlet weak var issueLabel: UILabel!

    var vc1: ViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let vc1 = vc1 else { return }
        guard let index = vc1.index else { return }
        let repo = vc1.repo[index]

        repoLanguageLabel.text = "Written in \(repo["language"] as? String ?? "")"
        starLabel.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        wachLabel.text = "\(repo["wachers_count"] as? Int ?? 0) watchers"
        forkLabel.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        issueLabel.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"

        getImage(repo: repo)

    }

    func getImage(repo: [String: Any]) {
        repoTitleLabel.text = repo["full_name"] as? String

        if let owner = repo["owner"] as? [String: Any] {
            if let imgURL = owner["avatar_url"] as? String {
                URLSession.shared.dataTask(with: URL(string: imgURL)!) { (data, res, err) in
                    guard let data = data else { return }
                    let img = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.avatarImageView.image = img
                    }
                }.resume()
            }
        }
    }

}
