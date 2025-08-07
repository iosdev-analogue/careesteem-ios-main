//
//  WebViewController.swift
//  CareEsteem
//
//  Created by Nitin Chauhan on 23/07/25.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    var url: String = "https://www.google.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.backgroundColor = .white
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: url)!))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        CustomLoader.shared.hideLoader()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        CustomLoader.shared.showLoader(on: self.view)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        CustomLoader.shared.hideLoader()
    }
}

