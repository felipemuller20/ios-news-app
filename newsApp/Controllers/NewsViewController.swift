//
//  NewsViewController.swift
//  newsApp
//
//  Created by Felipe Muller on 26/07/23.
//

import WebKit

class NewsViewController: UIViewController {
    
    @IBOutlet weak var newsWebView: WKWebView! // Cria webview lá na views "Main" e vincula a essa variável. Será o componente "principal" dessa view.
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView! // Componente de loading "activity indicator", arrastado da view pra cá.
    @IBOutlet weak var loadingView: UIView!

    var news: NewsModel? {
        didSet {
            self.title = news?.source.name // Seta o "title" lá no topo do app
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView()
    }
    
    private func setupWebView() {
        self.newsWebView.navigationDelegate = self // Delega o navigationDelegate. Para isso, criar a extension lá embaixo.
        guard let news = news, let url = URL(string: news.url) else { return } // garante que existe new e url
        self.newsWebView.load(URLRequest(url: url)) // a webview irá carregar o conteúdo da URL
        self.newsWebView.allowsBackForwardNavigationGestures = true
    }
}

extension NewsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.loadingActivityIndicator.startAnimating()
        self.loadingView.isHidden = false // garante que a view vai aparecer
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.loadingView.isHidden = true
        self.loadingActivityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.loadingView.isHidden = true
        self.loadingActivityIndicator.stopAnimating()
    }
}
