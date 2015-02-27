//
//  WebSearchViewController.swift
//  save5
//
//  Created by José Carlos Sobrino on 11/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//


import AVKit
import AVFoundation

class WebSearchViewController: UIViewController, UISearchBarDelegate, UIWebViewDelegate, UITableViewDelegate, NJKWebViewProgressDelegate, WebSearchRecentSearchesDelegate {

    @IBOutlet var webView:UIWebView!
    
    let searchEngine = "https://www.google.es/#q=%@"
    var playedVideo = false
    var urlVideo: NSURL?
    var historyBackButton: UIBarButtonItem!
    var historyForwardButton: UIBarButtonItem!
    var homeButton: UIBarButtonItem!
    var searchBar:UISearchBar!
    var progressProxy: NJKWebViewProgress!
   
    lazy var progressView: NJKWebViewProgressView = {
        
        let progressBarHeight = CGFloat(3.0)
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
        
        searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.showsBookmarkButton = true
        searchBar.barStyle = UIBarStyle.BlackTranslucent
        searchBar.getTextField()!.textColor = LookAndFeel.style.searchBarTextColor
        searchBar.setTextAlignment(NSTextAlignment.Center)
        searchBar.placeholder = "Search or enter website name"
        navigationItem.titleView = searchBar
        
        progressProxy = NJKWebViewProgress()
        progressProxy.webViewProxyDelegate = self
        progressProxy.progressDelegate = self
        
        webView.delegate = progressProxy
        webView.scalesPageToFit = true
        
        navigationController?.hidesBarsOnSwipe = true
        
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        historyBackButton = UIBarButtonItem(image: LookAndFeel.icons.goBackWebHistoryIcon, style: .Plain, target: webView, action: "goBack")
        historyForwardButton = UIBarButtonItem(image: LookAndFeel.icons.goForwardWebHistoryIcon, style: .Plain, target: webView, action: "goForward")
        homeButton = UIBarButtonItem(image: LookAndFeel.icons.goHomeWebHistoryIcon, style: .Plain, target: self, action: "goHome")
        
        setToolbarItems(NSArray(array: [historyBackButton!, flexibleButton, homeButton!, flexibleButton, historyForwardButton!]), animated: true)
        
        updateNavigationControls()
        goHome()
    }
    
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        
        updateNavigationControls()
        progressView.setProgress(0, animated: true)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        let title = webView.title
        let URL = webView.request?.URL
        
        searchBar!.text = title
        searchBar!.showReloadButton()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        (searchController.searchResultsController as WebBrowserRecentSearchesViewController).addRecentSearch(title, url: URL!.host!)
        
        updateNavigationControls()
    }
    
    func webViewProgress(webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
        
        progressView.setProgress(progress, animated: true)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        searchBar.showStopLoadingButton()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        return true
    }
    
    func goHome(){
        
        webView!.loadRequest(NSURLRequest(URL: NSURL(string: "https://www.youtube.com/watch?v=E9rjTTl7z3E")!))
    }
    
    func updateNavigationControls(){
        
        historyBackButton?.enabled = webView.canGoBack
        historyForwardButton?.enabled = webView.canGoForward
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.text = webView.request?.URL.host
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
        
        
        if(playedVideo){
        
            if(NSString(string: self.urlVideo!.lastPathComponent!).containsString("m3u8")){
                
                var alert = UIAlertController(title: Utils.localizedString("Message"), message: Utils.localizedString("This video cannot be downloaded :("), preferredStyle: .Alert)
                
                alert.addAction(UIAlertAction(title: Utils.localizedString("OK"), style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
            }
            
            
            let actionSheet =  UIAlertController(title: Utils.localizedString("A video was detected!"), message: self.webView.title, preferredStyle: .ActionSheet)
            
            let folders = FolderDAO.sharedInstance.findAll() as [Folder]
            let sourcePage = webView.request?.URL.absoluteString
            
            for folder in folders  {
                
                actionSheet.addAction(UIAlertAction(title: folder.name, style: .Default, handler: { (ACTION :UIAlertAction!)in
                        
                    DownloadManager.sharedInstance.downloadVideo(self.urlVideo!, name: self.webView.title, sourcePage: sourcePage!, folder: folder)
                }))
            
            }
            
            actionSheet.addAction(UIAlertAction(title: Utils.localizedString("Cancel"), style: .Cancel, handler: nil))
            self.presentViewController(actionSheet, animated: true, completion: nil)
    
            playedVideo = false
        }
    
    }
    
    func playerItemBecameCurrent(notification:NSNotification) {
       
        let player = notification.object as AVPlayerItem
        let asset = player.asset as AVURLAsset
        urlVideo = asset.URL
        playedVideo = true
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemBecameCurrent:",name: "AVPlayerItemBecameCurrentNotification", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "windowDidBecomeHidden:",name: "UIWindowDidBecomeHiddenNotification", object: nil);
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "AVPlayerItemBecameCurrentNotification", object: nil);
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "UIWindowDidBecomeHiddenNotification", object: nil);
    }

}
