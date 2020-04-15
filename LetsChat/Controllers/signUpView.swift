//
//  signUpView.swift
//  LetsChat
//
//  Created by Navjot Singh on 1/20/20.
//  Copyright © 2020 Navjot Singh. All rights reserved.
//

import UIKit
import WebKit

class signUpView: UIViewController, WKNavigationDelegate {
    
    
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webVw: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = URL(string: "https://www.xmpp.jp/signup")!
        webVw.load(URLRequest(url: url))
        webVw.navigationDelegate = self
        webVw.allowsBackForwardNavigationGestures = true
        
        actIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        actIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        actIndicator.stopAnimating()
    }
    
}
