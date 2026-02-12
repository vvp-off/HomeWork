//
//  WebView.swift
//  HomeWork
//
//  Created by VP on 09.02.2026.
//

import UIKit
import WebKit

class WebView: UIViewController {
    private let urlString: String
    private let web = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(web)
        guard let url = URL(string: urlString) else { return }
        web.load(URLRequest(url: url))
        web.frame = view.bounds
        web.allowsBackForwardNavigationGestures = true
    }
        
    init(url: String) {
        self.urlString = url
        super.init(nibName: nil, bundle:  nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
