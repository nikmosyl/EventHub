//
//  WebView.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 19.09.2025.
//

import Foundation

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

#Preview {
    WebView(url: "https://apple.com")
}
