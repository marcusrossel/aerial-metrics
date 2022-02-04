//
//  Extensions.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 29.01.22.
//

import SwiftUI
import WebKit
import Introspect

struct WebView: NSViewRepresentable {
 
    var url: URL
 
    func makeNSView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateNSView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension List {
    
  // List on macOS uses an opaque background with no option for
  // removing/changing it. listRowBackground() doesn't work either.
  // This workaround works because List is backed by NSTableView.
  func clearBackground() -> some View {
    return introspectTableView { tableView in
      tableView.backgroundColor = .clear
      tableView.enclosingScrollView!.drawsBackground = false
    }
  }
}
