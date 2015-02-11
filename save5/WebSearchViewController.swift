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
    var progressContext = 0
    let downloadManager = DownloadManager.sharedInstance
    var configuration = WKWebViewConfiguration()
    var controller = WKUserContentController()
    var webView:WKWebView?
    
    var historyBackButton: UIBarButtonItem?
    var historyForwardButton: UIBarButtonItem?
    var reloadPageButton: UIBarButtonItem?
    var stopLoadingButton: UIBarButtonItem?
    var findVideosButton: UIBarButtonItem?
    @IBOutlet weak var webViewPanel: UIView!
    @IBOutlet weak var progressLoading: UIProgressView!


    var searchBar:UISearchBar {
    
        
        if self._searchBar != nil {
            
            return self._searchBar!
        }
        
        let searchBarTemp = UISearchBar()
        
        searchBarTemp.translucent = true
        searchBarTemp.delegate = self
        searchBarTemp.barStyle = UIBarStyle.BlackTranslucent
        return searchBarTemp
    }
    
    var _searchBar:UISearchBar?
    
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
    
        var flexibleButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        historyBackButton = UIBarButtonItem(barButtonSystemItem: .Rewind, target: self, action: "historyBackButtonClicked")
        historyForwardButton = UIBarButtonItem(barButtonSystemItem: .FastForward, target: self, action: "historyForwardButtonClicked")
        reloadPageButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "reloadPageButtonClicked")
        stopLoadingButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "stopLoadingButtonClicked")
        findVideosButton = UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: self, action: "findVideosButtonClicked")
        
        setToolbarItems(NSArray(array: [historyBackButton!, flexibleButton, historyForwardButton!, flexibleButton, reloadPageButton!, flexibleButton, stopLoadingButton!, flexibleButton, findVideosButton!]), animated: true)
        
        navigationController?.hidesBarsOnSwipe = true
        navigationItem.titleView = searchBar
 
        webView!.loadRequest(NSURLRequest(URL: NSURL(string: "https://www.youtube.com/watch?v=_2xGW5TM5Rs")!))
        webView!.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.New, context: &progressContext)
        
        searchBar.showsBookmarkButton = true
        
        //searchBar.setImage(historyBackButton?.image, forSearchBarIcon: UISearchBarIcon.Bookmark, state: UIControlState.Normal)
    
        captureAllNotifications()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
       let location = searchBar.text
      
        searchBar.endEditing(true)
        
        var url = NSURL(string: location)
        
        if(url == nil || url?.host == nil || url?.scheme == nil){
            
            url = NSURL(string: String(format:"http://%@", location))
            
            if(url == nil || url?.host == nil || url?.scheme == nil){
                
                url = NSURL(string: String(format:searchEngine, location))
            }
        
        }
    
        let request = NSURLRequest(URL: url!)
       
        webView!.loadRequest(request)
    }
    
    func findVideosButtonClicked(){
        
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
        self.progressLoading.progress = 0
        searchBar.text = self.webView!.title
    }
    
    func updateNavigationControls(){
        
        historyBackButton?.enabled = webView!.canGoBack
        historyForwardButton?.enabled = webView!.canGoForward
    }
    
     func historyForwardButtonClicked(){
        
        self.webView?.goForward()
    }
    
    func historyBackButtonClicked(){
        
        self.webView?.goBack()
    }
    
    func reloadPageButtonClicked(){
        
        self.webView?.reload()
    }
    
    func stopLoadingButtonClicked(){
        
        self.webView?.stopLoading()
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
        searchBar.showsCancelButton = true
        searchBar.text = self.webView!.URL?.host
        return true
    }
    
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        
        searchBar.showsCancelButton = false
        searchBar.text = self.webView!.title
        return true
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
    }
    
   
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject: AnyObject], context: UnsafeMutablePointer<Void>) {
        
        if context == &progressContext {
            
            progressLoading.progress = Float(webView!.estimatedProgress)
        }
    }
    
    
    func captureAllNotifications(){
    
    //    NSNotificationCenter.defaultCenter().addObserver(self,
    //        selector: "playerItemBecameCurrent:",
    //        name: "AVPlayerItemBecameCurrentNotification", object: nil);
        
        
        
        
       
    }
    
    func playerItemBecameCurrent(notification:NSNotification){
        
        println(notification)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        println("hola!")
    }
}
