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
    let downloadManager = DownloadManager.sharedInstance
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
        
        controller.addScriptMessageHandler(self, name: "video")
        configuration.userContentController = controller;
        
        webView = WKWebView(frame: webViewPanel.bounds, configuration: configuration)
        webView?.autoresizingMask = .FlexibleWidth
        webView!.navigationDelegate = self
        webViewPanel.addSubview(webView!)
        
        updateNavigationControls()
       
        
        webView!.loadRequest(NSURLRequest(URL: NSURL(string: "https://www.youtube.com/watch?v=_2xGW5TM5Rs")!))
        
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
        
        var js = "function getHTML5Videos() { "
        js += "var videos = []; "
        js += "var elements = document.querySelectorAll(\"video, source\"); "
        js += "for (i = 0; i < elements.length; i++) { "
        js += "var video = elements[i]; "
        js += "videos.push({src: video.src, title: video.title, name: video.name, type: video.type}); "
        js += "} "
        js += "window.webkit.messageHandlers.video.postMessage({videos: videos}); "
        js += "}"
        js += "getHTML5Videos();"
        
        
        self.webView?.evaluateJavaScript(js) { (_, error) in
            
            if(error != nil) {
                
                println(error)
            }
        }
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = self.webView!.loading
        let alert = UIAlertController(title: "An error was captured", message: error.domain, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: Utils.localizedString("Ok"), style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage){
        
        var output = message.body as NSDictionary
        var videos = output.objectForKey("videos") as NSArray
        
        let actionSheet =  UIAlertController(title: Utils.localizedString("Select video"), message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        
        for video in videos {
            
            if !(video.objectForKey("src") as String).isEmpty {
                
                var src = video.objectForKey("src") as String
                let videoURL = NSURL(string: src)
                let title = webView!.title!
                
                actionSheet.addAction(UIAlertAction(title: src, style: UIAlertActionStyle.Default, handler: { (ACTION :UIAlertAction!)in
                    
                    self.downloadManager.downloadVideo(videoURL!, name: title)
                    
                }))
            }
          
        }
        
        actionSheet.addAction(UIAlertAction(title: Utils.localizedString("Cancel"), style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(actionSheet, animated: true, completion: nil)

    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = self.webView!.loading
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        updateNavigationControls()
        self.title = self.webView!.title
        UIApplication.sharedApplication().networkActivityIndicatorVisible = self.webView!.loading
    }
    
    func updateNavigationControls(){
        
        self.historyBack.enabled = webView!.canGoBack
        self.historyForward.enabled = webView!.canGoForward
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func goHistoryForward(){
        
        self.webView?.goForward()
    }
    
    @IBAction func goHistoryBack(){
        
        self.webView?.goBack()
    }
    
    @IBAction func reloadPage(){
        
        self.webView?.reload()
    }
    
    @IBAction func stopLoading(){
        
        self.webView?.stopLoading()
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
