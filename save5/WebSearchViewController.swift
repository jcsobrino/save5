//
//  WebSearchViewController.swift
//  save5
//
//  Created by José Carlos Sobrino on 31/01/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit
import WebKit

class WebSearchViewController: UIViewController, UISearchBarDelegate, WKNavigationDelegate, WKScriptMessageHandler {

    let searchEngine = "http://www.google.es/q=%d"
    var configuration = WKWebViewConfiguration()
    var controller = WKUserContentController()
    var webView:WKWebView?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var historyBack: UIBarButtonItem!
    @IBOutlet weak var historyForward: UIBarButtonItem!
    @IBOutlet weak var refreshPage: UIBarButtonItem!
    @IBOutlet weak var cancelLoading: UIBarButtonItem!
    @IBOutlet weak var findVideos: UIBarButtonItem!
    @IBOutlet weak var webViewPanel: UIView!
    @IBOutlet weak var progressLoading: UIProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        controller.addScriptMessageHandler(self, name: "xxx")
        configuration.userContentController = controller;
        
        webView = WKWebView(frame: webViewPanel.bounds, configuration: configuration)
        webView!.navigationDelegate = self
        webViewPanel.addSubview(webView!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        
        
        var url = NSURL(string: searchBar.text)
        
        if(url == nil || url?.host == nil || url?.scheme == nil){
            
            url = NSURL(string: String(format:"http://%@", searchBar.text))
            
            if(url == nil || url?.host == nil || url?.scheme == nil){
                
                url = NSURL(string: String(format:searchEngine, searchBar.text))
            }
        
        }
    
        let request = NSURLRequest(URL: url!)
       
        webView!.loadRequest(request)
    }
    
    @IBAction func discoverVideoTags(){
        
        var js = "function getRelatedArticles() { "
        js += "var related = []; "
        js += "var elements = document.getElementsByTagName(\"video\"); "
        js += "for (i = 0; i < elements.length; i++) { "
        js += "var a = elements[i]; "
        js += "related.push({data: a.innerHTML, src: a.src, title: a.title}); "
        js += "} "
        js += "window.webkit.messageHandlers.xxx.postMessage({videos: related}); "
        js += "}"
        js += "getRelatedArticles();"
        
        self.webView?.evaluateJavaScript(js) { (_, error) in
            
            if(error != nil) {
                
                println(error)
            }
        }
        
        
        
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage){
        
        println(message.body)
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        println("did")
    }
    
    
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
        searchBar.showsCancelButton = true
        return true
    }
    
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        
        searchBar.showsCancelButton = false
        return true
    }
    
}
