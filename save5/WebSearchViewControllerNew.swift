//
//  WebSearchViewController.swift
//  save5
//
//  Created by José Carlos Sobrino on 31/01/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit
import WebKit

class WebSearchViewControllerNew: UIViewController, UISearchBarDelegate, WKNavigationDelegate, WKScriptMessageHandler, WebSearchRecentSearchesDelegate {
   
    @IBOutlet weak var webViewPanel: UIView!
    
    let searchEngine = "https://www.google.es/#q=%@"
    var progressContext = 0
    var configuration = WKWebViewConfiguration()
    var controller = WKUserContentController()
    var webView:WKWebView!
    var searchBar:UISearchBar!
    
    lazy var progressView: NJKWebViewProgressView = {
        
        let progressBarHeight = CGFloat(2.0)
        let navigationBarBounds = self.navigationController!.navigationBar.bounds;
        let barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
        let progressViewAux = NJKWebViewProgressView(frame: barFrame)
        progressViewAux.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleTopMargin
        self.navigationController!.navigationBar.addSubview(progressViewAux)
        
        return progressViewAux
    }()
    
    lazy var searchController: UISearchController = {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let recentSearchesController = storyBoard.instantiateViewControllerWithIdentifier("WebBrowserRecentSearchesViewController") as WebBrowserRecentSearchesViewController
        let searchControllerAux = UISearchController(searchResultsController: recentSearchesController)
        searchControllerAux.hidesNavigationBarDuringPresentation = false
        searchControllerAux.dimsBackgroundDuringPresentation = false
        searchControllerAux.searchResultsUpdater = recentSearchesController
        searchControllerAux.definesPresentationContext = true
        searchControllerAux.searchBar.sizeToFit()
        recentSearchesController.delegate = self
        
        return searchControllerAux
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = LookAndFeel.style.mainColor
        
        controller.addScriptMessageHandler(self, name: "video")
        configuration.userContentController = controller;
        
        webView = WKWebView(frame: webViewPanel.bounds, configuration: configuration)
        webView.autoresizingMask = .FlexibleWidth
        webView.navigationDelegate = self
        webViewPanel.addSubview(webView)
        webView.allowsBackForwardNavigationGestures = true
        
        searchBar = searchController.searchBar
        searchBar.barStyle = UIBarStyle.BlackTranslucent
        searchBar.sizeToFit()
        searchBar.getTextField()!.textColor = LookAndFeel.style.searchBarTextColor
        searchBar.showReloadButton()
        searchBar.showsBookmarkButton = true
        searchBar.placeholder = Utils.localizedString("Search or enter website name")
        searchBar.delegate = self
        searchBar.setTextAlignment(NSTextAlignment.Center)
        searchBar.text = Utils.localizedString("Search or enter website name")
        navigationItem.titleView = searchBar
        
        webView!.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.New, context: &progressContext)
        
        navigationController?.hidesBarsOnSwipe = true
        
        goHome()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func findVideosButtonClicked(){
        
        var js = "function getHTML5Videos() { "
        js += "var videos = []; "
        js += "var elements = document.querySelectorAll(\"video, source\"); "
        js += "for (i = 0; i < elements.length; i++) { "
        js += "var video = elements[i]; "
        js += "videos.push({src: video.src, title: video.title, name: video.name, type: video.type}); "
        js += "} "
        js += "for(f = 0; f < window.frames.length; f++) { "
        js += "var elements2 = window.frames[10].document.querySelectorAll(\"video, source\"); "
        
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
        
        progressView.setProgress(0, animated: true)
    }
    
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        let title = webView.title!
        let URL = webView.URL
        
        searchBar!.text = title
        searchBar!.showReloadButton()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        (searchController.searchResultsController as WebBrowserRecentSearchesViewController).addRecentSearch(title, url: URL!.host!)
    }
    
    func webViewProgress(webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
        
        progressView.setProgress(progress, animated: true)
        
        if(progress < 0.9){
            
            searchBar.showStopLoadingButton()
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        return true
    }
    
    func goHome(){
        
        webView!.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.lamoscamediatica.com/2015/03/jorge-javier-se-revuelve-mediaset.html")!))
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.text = webView.URL!.host
        searchBar.setTextAlignment(NSTextAlignment.Natural)
        searchBar.showsBookmarkButton = false
        
        return true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        searchController.active = false
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.setTextAlignment(NSTextAlignment.Center)
        searchBar.showsBookmarkButton = true
        
        Async.main {
            
            searchBar.text = self.webView.title
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        searchBar.selectAllText()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchBar.endEditing(false)
    }
    
    func windowDidBecomeHidden(notification:NSNotification) {
     
        findVideosButtonClicked()
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage){
        
        var output = message.body as NSDictionary
        var videos = output.objectForKey("videos") as NSArray
        var urlVideo : NSURL?
        var titleVideo : String?
        var playedVideo = false
        
        if(videos.count > 0){
        
         for video in videos {
            
            println(video)
            
            if !(video.objectForKey("src") as String).isEmpty {
                
                var src = video.objectForKey("src") as String
                urlVideo = NSURL(string: src)
                titleVideo = (video.objectForKey("title") as String).isEmpty ? self.webView.title : video.objectForKey("title") as? String
                playedVideo = true
                
            }
          }
        }
        
 
        if(playedVideo){
            
            if(NSString(string: urlVideo!.lastPathComponent!).containsString("m3u8")){
                
                var alert = UIAlertController(title: Utils.localizedString("Message"), message: Utils.localizedString("This video cannot be downloaded :("), preferredStyle: .Alert)
                
                alert.addAction(UIAlertAction(title: Utils.localizedString("OK"), style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
            }
            
            let actionSheet =  UIAlertController(title: Utils.localizedString("A video was detected!"), message: titleVideo, preferredStyle: .ActionSheet)
            
            let folders = FolderDAO.sharedInstance.findAll() as [Folder]
            let sourcePage = webView.URL!.absoluteString
            
            for folder in folders  {
                
                actionSheet.addAction(UIAlertAction(title: folder.name, style: .Default, handler: { (ACTION :UIAlertAction!)in
                    
                    DownloadManager.sharedInstance.downloadVideo(urlVideo!, name: titleVideo!, sourcePage: sourcePage!, folder: folder)
                }))
                
            }
            
            actionSheet.addAction(UIAlertAction(title: Utils.localizedString("Cancel"), style: .Cancel, handler: nil))
            self.presentViewController(actionSheet, animated: true, completion: nil)
            
            playedVideo = false
        }
        
    }
    

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        let location = searchBar.text
        
        searchBar.endEditing(true)
        
        var url: NSURL?
        
        if(Utils.isValidURL(location)){
            
            url = NSURL(string: location)
            
        } else if(Utils.isValidURL(String(format:"http://%@", location))){
            
            url = NSURL(string: String(format:"http://%@", location))
            
        } else {
            
            url = NSURL(string: String(format:searchEngine, location.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!))
        }
        
        let request = NSURLRequest(URL: url!)
        
        webView!.loadRequest(request)
    }
    
    func searchBarBookmarkButtonClicked(searchBar: UISearchBar) {
        
        if(searchBar.isReloadButtonActive()){
            
            webView.reload()
            
        } else {
            
            webView.stopLoading()
        }
    }
    
    func recentSearchSelected (webBrowserRecentSearches: WebBrowserRecentSearchesViewController, URL:String) {
        
        searchBar.text = URL
        searchBarSearchButtonClicked(searchBar)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject: AnyObject], context: UnsafeMutablePointer<Void>) {
        
        if context == &progressContext {
            
            progressView.progress = Float(webView!.estimatedProgress)
             //progressLoading.progress = Float(webView!.estimatedProgress)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "windowDidBecomeHidden:",name: "UIWindowDidBecomeHiddenNotification", object: nil);
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "UIWindowDidBecomeHiddenNotification", object: nil);
    }

    
    
}
