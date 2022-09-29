//
//  WKWebView+Extensions.swift
//  HackerNews
//
//  Created by MinKyeongTae on 2022/09/29.
//

import Foundation
import WebKit

extension WKWebView {
  static func pageNotFoundView() -> WKWebView {
    let wkWebView = WKWebView()
    wkWebView.loadHTMLString("<html><body><h1>Page not found!</h1></body></html>", baseURL: nil)
    return wkWebView
  }
}

