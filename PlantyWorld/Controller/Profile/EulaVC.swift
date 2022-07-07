//
//  EulaVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/7/7.
//

import Foundation
import UIKit
import WebKit

class EulaVC: UIViewController {

    var mWebView: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let url = "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
        loadURL(urlString: url)

        mWebView?.navigationDelegate = self

        navigationItem.leftBarButtonItem = UIBarButtonItem(
                    image: UIImage(systemName: "chevron.left")?
                        .withTintColor(UIColor.darkGray)
                        .withRenderingMode(.alwaysOriginal),
                    style: .plain,
                    target: self,
                    action: #selector(didTapClose)
                )
        title = "123123"
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

    private func loadURL(urlString: String) {
        let url = URL(string: urlString)
        if let url = url {
            let request = URLRequest(url: url)
            mWebView = WKWebView(frame: CGRect(x: 0, y: 50, width: UIScreen.width, height: UIScreen.height))

            if let mWebView = mWebView {
                mWebView.navigationDelegate = self
                mWebView.load(request)
                self.view.addSubview(mWebView)
                self.view.sendSubviewToBack(mWebView)
            }
        }
    }

    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }

}

extension EulaVC: WKNavigationDelegate {
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
