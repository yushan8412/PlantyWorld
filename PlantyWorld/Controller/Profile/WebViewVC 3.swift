//
//  WebViewVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/7/5.
//

import Foundation
import UIKit
import WebKit

class WebVC: UIViewController {
    var mWebView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let url = "https://www.privacypolicies.com/live/a489ae6d-2643-4663-9aac-9d2279d509b6"
        loadURL(urlString: url)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func loadURL(urlString: String) {
        let url = URL(string: urlString)
        if let url = url {
            let request = URLRequest(url: url)
            mWebView = WKWebView(frame: CGRect(x: 0, y: 100, width: UIScreen.width, height: UIScreen.height))

            if let mWebView = mWebView {
                mWebView.navigationDelegate = self
                mWebView.load(request)
                self.view.addSubview(mWebView)
                self.view.sendSubviewToBack(mWebView)
            }
        }
    }
        
}

extension WebVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }
}
