//
//  ViewController.swift
//  Project 4
//
//  Created by Avinash Muralidharan on 29/08/23.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate{
    
    @IBOutlet var webView: WKWebView!
    var progressView : UIProgressView!
    var bookmarks : [String]!
    var initialSite :String!
    var searchBar:UISearchBar!
   
    override func loadView() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
    
        searchBar = UISearchBar(frame: CGRectMake(0, 0, 250, 20))
        searchBar.placeholder = "www.google.com"
        
        let searchBarButton = UIBarButtonItem(customView:searchBar)

       
        let hamburgerButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(openTapped))
        
        let searchButton = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(search))
        
        navigationItem.rightBarButtonItems = [hamburgerButton,searchButton,searchBarButton]
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        let back = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(goBack))
        
        let forward = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(goForward))
        
        progressView = UIProgressView(progressViewStyle: .default)
        
        progressView.frame = CGRect(x: 200, y: 0, width: 250,height: 100)
        
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [back,forward,spacer,progressButton,spacer,refresh]
        
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string:"https://" + initialSite)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    
   
    @objc func goBack(){
        if (self.webView.canGoBack) {
                    self.webView.goBack()
                }
    }
    
    @objc func goForward(){
        if (self.webView.canGoForward) {
                    self.webView.goForward()
                }
    }
    
    @objc func search(){
      
        let query = "https://www.google.com/search?q="+(searchBar.text?.replacingOccurrences(of: " ", with: "+") ?? "")
        let url = URL(string:query)!
        webView.load(URLRequest(url: url))
    }
    
    @objc func openTapped(){
        
        let ac = UIAlertController(title: "Bookmarks", message: nil, preferredStyle: .actionSheet)
        
        for website in bookmarks{
            ac.addAction(UIAlertAction(title: website, style: .default , handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Add to Bookmarks", style:.default ,handler:addBookmark))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(ac,animated:true)
    }
    func addBookmark(action: UIAlertAction! = nil){
        let url = webView.url?.absoluteString
        if let site = url?.split(separator: "/")[1]{
            let siteString = String(site)
            bookmarks.append(siteString)
        }
        else{
           return
        }
    }
    func openPage(action: UIAlertAction! ){
        guard let actionTitle = action.title else{ return }
        guard let url = URL(string:"https://" + actionTitle) else { return }
        webView.load(URLRequest(url: url))
        print(url)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        searchBar.placeholder = webView.url?.absoluteString
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    
}

