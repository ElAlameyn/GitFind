//
//  DetailViewController.swift
//  GitFind
//
//  Created by Артем Калинкин on 02.10.2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
  var url: URL?
  
  var webView: WKWebView!
  
  override func loadView() {
    webView = WKWebView()
    webView.navigationDelegate = self
    view = webView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let url = url else { return }
    webView.load(URLRequest(url: url))
  }
}
