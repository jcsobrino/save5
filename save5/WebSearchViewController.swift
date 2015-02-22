//
//  WebSearchViewController.swift
//  save5
//
//  Created by José Carlos Sobrino on 11/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//


import AVKit
import AVFoundation

class WebSearchViewController: UIViewController, UISearchBarDelegate, UIWebViewDelegate, NJKWebViewProgressDelegate {

    let searchEngine = "https://www.google.es/#q=%@"
    var playedVideo = false
    var urlVideo: NSURL?
    var nameVideo: String?
    var historyBackButton: UIBarButtonItem?
    var historyForwardButton: UIBarButtonItem?
    var homeButton: UIBarButtonItem?
    var searchBar:UISearchBar?
    var progressView: NJKWebViewProgressView?
    var progressProxy: NJKWebViewProgress?

    lazy var recentSearchesSearchController: UISearchController = {

        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let recentSearchesController = storyBoard.instantiateViewControllerWithIdentifier("WebBrowserRecentSearchesViewController") as WebBrowserRecentSearchesViewController
        let controller = UISearchController(searchResultsController: recentSearchesController)
        controller.hidesNavigationBarDuringPresentation = false
        controller.dimsBackgroundDuringPresentation = false
        controller.searchResultsUpdater = recentSearchesController
        controller.definesPresentationContext = true
        controller.searchBar.sizeToFit()
        recentSearchesController.lookup = self
        return controller
    }()
    
    @IBOutlet var webView:UIWebView!
    @IBOutlet weak var progressLoading: UIProgressView!
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        searchBar = recentSearchesSearchController.searchBar //UISearchBar()
        
        searchBar!.delegate = self
        searchBar!.showsBookmarkButton = true
        searchBar!.barStyle = UIBarStyle.BlackTranslucent
        searchBar!.getTextField()!.textColor = LookAndFeel.style.searchBarTextColor
        searchBar!.setTextAlignment(NSTextAlignment.Center)
        
        progressProxy = NJKWebViewProgress()
        webView.delegate = progressProxy
        webView.scalesPageToFit = true
        progressProxy!.webViewProxyDelegate = self
        progressProxy!.progressDelegate = self
        
        
        var progressBarHeight = CGFloat(3.0)
        var navigaitonBarBounds = self.navigationController!.navigationBar.bounds;
        var barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
        progressView = NJKWebViewProgressView(frame: barFrame)
        progressView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleTopMargin
        
        self.navigationController!.navigationBar.addSubview(progressView!)
        
        navigationController?.hidesBarsOnSwipe = true
        navigationItem.titleView = searchBar
        updateNavigationControls()
        
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        historyBackButton = UIBarButtonItem(image: LookAndFeel.icons.goBackWebHistoryIcon, style: .Plain, target: webView, action: "goBack")
        historyForwardButton = UIBarButtonItem(image: LookAndFeel.icons.goForwardWebHistoryIcon, style: .Plain, target: webView, action: "goForward")
        homeButton = UIBarButtonItem(image: LookAndFeel.icons.goHomeWebHistoryIcon, style: .Plain, target: self, action: "goHome")
        
        setToolbarItems(NSArray(array: [historyBackButton!, flexibleButton, homeButton!, flexibleButton, historyForwardButton!]), animated: true)
        
        goHome()
        
        
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: "backGesture:")
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        webView.addGestureRecognizer(leftSwipe)
        webView.userInteractionEnabled = true
        
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: "forwardGesture:")
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        webView.addGestureRecognizer(rightSwipe)

    }
    
    func goHome(){
        
        webView!.loadRequest(NSURLRequest(URL: NSURL(string: "https://www.google.es")!))
    }
    
    func backGesture(recognizer:UISwipeGestureRecognizer){
        
        webView.goBack()
        
        println("back")
    }
    
    func forwardGesture(recognizer:UISwipeGestureRecognizer){
        
        webView.goForward()
        
        println("forward")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        
        updateNavigationControls()
        progressView?.setProgress(0, animated: true)
        println("didFailLoadWithError")
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        
        //updateNavigationControls()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        searchBar!.text = webView.stringByEvaluatingJavaScriptFromString("document.title")
        let searchBarIcon = LookAndFeel.icons.reloadIcon
        searchBar!.setImage(searchBarIcon, forSearchBarIcon: UISearchBarIcon.Bookmark, state: .Normal)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        updateNavigationControls()
        
        let aux = recentSearchesSearchController.searchResultsController as WebBrowserRecentSearchesViewController
        let title = webView.stringByEvaluatingJavaScriptFromString("document.title")
        let URL = webView.request?.URL
        
        aux.addRecentSearch(title!, newURL: URL!.absoluteString!)
        
        println("webViewDidFinishLoad")
    }
    
    func webViewProgress(webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
        
        progressView?.setProgress(progress, animated: true)
        
        println("webViewProgress")
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let searchBarIcon = LookAndFeel.icons.stopLoadingIcon
        searchBar!.setImage(searchBarIcon, forSearchBarIcon: UISearchBarIcon.Bookmark, state: .Normal)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        println("shouldStartLoadWithRequest")
        return true
    }
    
    func updateNavigationControls(){
        
        historyBackButton?.enabled = webView.canGoBack
        historyForwardButton?.enabled = webView.canGoForward
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = webView.loading
        
        //let searchBarIcon = webView.loading ? LookAndFeel().stopLoadingIcon : LookAndFeel().reloadIcon
        
        //searchBar!.setImage(searchBarIcon, forSearchBarIcon: UISearchBarIcon.Bookmark, state: UIControlState.Normal)
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.text = webView.request?.URL.host
        searchBar.setTextAlignment(NSTextAlignment.Natural)
        recentSearchesSearchController.active = true
        return true
    }
    
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = webView.stringByEvaluatingJavaScriptFromString("document.title")
        searchBar.setTextAlignment(NSTextAlignment.Center)
        recentSearchesSearchController.active = false
        
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
    }
    
    func windowDidBecomeHidden(notification:NSNotification) {
        
        
        if(playedVideo){
        
            if(NSString(string: self.urlVideo!.lastPathComponent!).containsString("m3u8")){
                
                var alert = UIAlertController(title: Utils.localizedString("Message"), message: Utils.localizedString("This video cannot be downloaded :("), preferredStyle: .Alert)
                
                alert.addAction(UIAlertAction(title: Utils.localizedString("OK"), style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
            }
            
            
            let actionSheet =  UIAlertController(title: Utils.localizedString("A video was detected!"), message: nameVideo, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let folders = FolderDAO.sharedInstance.findAll() as [Folder]
            let sourcePage = webView.request?.URL.absoluteString
            
            for folder in folders  {
                
                actionSheet.addAction(UIAlertAction(title: folder.name, style: UIAlertActionStyle.Default, handler: { (ACTION :UIAlertAction!)in
                        
                    DownloadManager.sharedInstance.downloadVideo(self.urlVideo!, name: self.nameVideo!, sourcePage: sourcePage!, folder: folder)
                }))
            
            }
            
            actionSheet.addAction(UIAlertAction(title: Utils.localizedString("Cancel"), style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(actionSheet, animated: true, completion: nil)
    
            playedVideo = false
        }
    
    }
    
    func playerItemBecameCurrent(notification:NSNotification) {
       
        let player = notification.object as AVPlayerItem
        let asset = player.asset as AVURLAsset
        urlVideo = asset.URL
        nameVideo = webView.stringByEvaluatingJavaScriptFromString("document.title")!
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
    
        if(searchBar.imageForSearchBarIcon(UISearchBarIcon.Bookmark, state: UIControlState.Normal) == LookAndFeel.icons.stopLoadingIcon){
            
            webView.stopLoading()
        
        } else {
            
            webView.reload()
        }
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

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }

}
