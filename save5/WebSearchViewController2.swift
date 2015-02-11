//
//  WebSearchViewController2.swift
//  save5
//
//  Created by José Carlos Sobrino on 11/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//


import AVKit
import AVFoundation

class WebSearchViewController2: UIViewController, UISearchBarDelegate, UIWebViewDelegate, NJKWebViewProgressDelegate {

    let searchEngine = "https://www.google.es/#q=%@"
    var videoShow = false
    
    var historyBackButton: UIBarButtonItem?
    var historyForwardButton: UIBarButtonItem?
    var reloadPageButton: UIBarButtonItem?
    var stopLoadingButton: UIBarButtonItem?
    var searchBar:UISearchBar?
    var progressView: NJKWebViewProgressView?
    var progressProxy: NJKWebViewProgress?
    
    @IBOutlet var webView:UIWebView!
    @IBOutlet weak var progressLoading: UIProgressView!
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        searchBar = UISearchBar()
        searchBar!.translucent = true
        searchBar!.delegate = self
        searchBar!.barStyle = UIBarStyle.BlackTranslucent
        
        progressProxy = NJKWebViewProgress()
        webView.delegate = progressProxy
        progressProxy!.webViewProxyDelegate = self
        progressProxy!.progressDelegate = self
        
        navigationController?.hidesBarsOnSwipe = true
        navigationItem.titleView = searchBar
        updateNavigationControls()
        
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        historyBackButton = UIBarButtonItem(barButtonSystemItem: .Rewind, target: self, action: "historyBackButtonClicked")
        historyForwardButton = UIBarButtonItem(barButtonSystemItem: .FastForward, target: self, action: "historyForwardButtonClicked")
        reloadPageButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "reloadPageButtonClicked")
        stopLoadingButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "stopLoadingButtonClicked")
        
        setToolbarItems(NSArray(array: [historyBackButton!, flexibleButton, historyForwardButton!]), animated: true)
        
        webView!.loadRequest(NSURLRequest(URL: NSURL(string: "https://www.youtube.com")!))
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemBecameCurrent:",name: "AVPlayerItemBecameCurrentNotification", object: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = self.webView!.loading
        let alert = UIAlertController(title: "An error was captured", message: error.domain, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: Utils.localizedString("Ok"), style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        
        videoShow = false
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        navigationItem.setRightBarButtonItem(stopLoadingButton, animated: false)
        progressLoading.progress = 0
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        updateNavigationControls()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        searchBar!.text = webView.stringByEvaluatingJavaScriptFromString("document.title")
        navigationItem.setRightBarButtonItem(reloadPageButton, animated: false)
        progressLoading.progress = 0
    }
    
    func webViewProgress(webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
        
        progressLoading.progress = progress
    }
    
    func updateNavigationControls(){
        
        historyBackButton?.enabled = webView.canGoBack
        historyForwardButton?.enabled = webView.canGoForward
    }
    
    func historyForwardButtonClicked(){
        
        webView.goForward()
    }
    
    func historyBackButtonClicked(){
        
        webView.goBack()
    }
    
    func reloadPageButtonClicked(){
        
        webView.reload()
    }
    
    func stopLoadingButtonClicked(){
        
        webView.stopLoading()
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.text = webView.request?.URL.host
        return true
    }
    
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = webView.stringByEvaluatingJavaScriptFromString("document.title")
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
    }
    
    func playerItemBecameCurrent(notification:NSNotification){
       
        if(!videoShow){
         
            videoShow = true
            webView.stringByEvaluatingJavaScriptFromString("var videos = document.querySelectorAll(\"video\"); for (var i = videos.length - 1; i >= 0; i--) { videos[i].pause(); };")
        
            let player = notification.object as AVPlayerItem
            let asset = player.asset as AVURLAsset
            let urlVideo = asset.URL
            let nameVideo = webView.stringByEvaluatingJavaScriptFromString("document.title")!
    
            let actionSheet =  UIAlertController(title: Utils.localizedString("A video was detected!"), message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
            actionSheet.addAction(UIAlertAction(title: nameVideo, style: UIAlertActionStyle.Default, handler: { (ACTION :UIAlertAction!)in
                    
                DownloadManager.sharedInstance.downloadVideo(urlVideo!, name: nameVideo)
            }))
        
            actionSheet.addAction(UIAlertAction(title: Utils.localizedString("Cancel"), style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(actionSheet, animated: true, completion: nil)
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
        
        println(url)
        let request = NSURLRequest(URL: url!)
        
        webView!.loadRequest(request)
    }
}
