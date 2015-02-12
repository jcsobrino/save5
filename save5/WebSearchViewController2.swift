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

    struct icons {
        
        static let _iconSize = CGSize(width: 18.0, height: 18.0)
        static let reload =  FAKFoundationIcons.refreshIconWithSize(_iconSize.width).imageWithSize(_iconSize)
        static let stop =  FAKFoundationIcons.xIconWithSize(_iconSize.width).imageWithSize(_iconSize)
    }
    
    let searchEngine = "https://www.google.es/#q=%@"
    var videoShow = false
    
    var historyBackButton: UIBarButtonItem?
    var historyForwardButton: UIBarButtonItem?
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
        
        searchBar!.showsBookmarkButton = true
        searchBar!.setImage(icons.reload, forSearchBarIcon: UISearchBarIcon.Bookmark, state: UIControlState.Normal)
        
        webView.scalesPageToFit = true
        
        progressProxy = NJKWebViewProgress()
        webView.delegate = progressProxy
        progressProxy!.webViewProxyDelegate = self
        progressProxy!.progressDelegate = self
        
        navigationController?.hidesBarsOnSwipe = true
        navigationItem.titleView = searchBar
        updateNavigationControls()
        
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        historyBackButton = UIBarButtonItem(barButtonSystemItem: .Rewind, target: webView, action: "goBack")
        historyForwardButton = UIBarButtonItem(barButtonSystemItem: .FastForward, target: webView, action: "goForward")
        
        setToolbarItems(NSArray(array: [historyBackButton!, flexibleButton, historyForwardButton!]), animated: true)
        
        webView!.loadRequest(NSURLRequest(URL: NSURL(string: "https://www.youtube.com")!))
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemBecameCurrent:",name: "AVPlayerItemBecameCurrentNotification", object: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        
        updateNavigationControls()
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        
        videoShow = false
        updateNavigationControls()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        searchBar!.text = webView.stringByEvaluatingJavaScriptFromString("document.title")
        updateNavigationControls()
    }
    
    func webViewProgress(webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
        
        progressLoading.progress = progress
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return true
    }
    
    func updateNavigationControls(){
        
        historyBackButton?.enabled = webView.canGoBack
        historyForwardButton?.enabled = webView.canGoForward
        UIApplication.sharedApplication().networkActivityIndicatorVisible = webView.loading
        progressLoading.progress = 0
        
        let searchBarIcon = webView.loading ? icons.stop : icons.reload
        
        searchBar!.setImage(searchBarIcon, forSearchBarIcon: UISearchBarIcon.Bookmark, state: UIControlState.Normal)
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.text = webView.request?.URL.host
        selectTextSearchBar()
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
    
    func searchBarBookmarkButtonClicked(searchBar: UISearchBar) {
    
        if(webView.loading){
            
            webView.stopLoading()
        
        } else {
            
            webView.reload()
        }
    }
    
    func selectTextSearchBar(){
        
        for subview in searchBar!.subviews[0].subviews {
            
            if subview is UITextField{
            
                var textField = subview as UITextField
                textField.textRangeFromPosition(textField.beginningOfDocument, toPosition: textField.endOfDocument)
                
            }
        }
    }
}
