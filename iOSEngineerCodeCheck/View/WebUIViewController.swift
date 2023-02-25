//
//  WebUIViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 濵田　悠樹 on 2023/02/26.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit
import WebKit

// URL に応じてWebページをUIViewControllerとして返す
class WebUIViewContorller: UIViewController {
    var url: String!
    var barTitle: String!
    var uiScrollView = UIScrollView()

    init(url: String, barTitle: String) {
        super.init(nibName: nil, bundle: nil)

        self.url = url
        self.barTitle = barTitle
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupLayout()
    }

    func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = self.barTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(tapDismissButton(_:)))
    }

    func setupLayout() {
        let webView = WKWebView(frame: view.frame)
        let request = URLRequest(url: URL(string: self.url)!)
        view.addSubview(webView)
        webView.load(request)

        view.addSubview(webView)
    }

    @objc func tapDismissButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
