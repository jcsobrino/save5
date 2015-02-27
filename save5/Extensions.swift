//
//  Extensions.swift
//  save5
//
//  Created by José Carlos Sobrino on 12/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import Foundation
import UIKit
import iAd

extension UISearchBar{
    
    
    func getTextField() -> UITextField? {
        
        for subview in self.subviews[0].subviews {
            
            if subview is UITextField{
                
                return subview as? UITextField
            }
        }
        
        return nil
    }
    
    func setTextAlignment(textAlign: NSTextAlignment){
        
        getTextField()?.textAlignment = textAlign
    }
    
    func selectAllText(){
        
        Async.main {
        
            let textField = self.getTextField()
            textField?.selectedTextRange = textField?.textRangeFromPosition(textField?.beginningOfDocument, toPosition: textField?.endOfDocument)
        }
    }
    
    func showReloadButton(){
        
        self.setImage(LookAndFeel.icons.reloadIcon, forSearchBarIcon: .Bookmark, state: .Normal)
    }
    
    func showStopLoadingButton(){
        
        self.setImage(LookAndFeel.icons.stopLoadingIcon, forSearchBarIcon: .Bookmark, state: .Normal)
    }

    func isReloadButtonActive() -> Bool {
     
        return self.imageForSearchBarIcon(.Bookmark, state: .Normal) == LookAndFeel.icons.reloadIcon
    }

}

extension UIViewController: ADBannerViewDelegate {
    
    var viewBehind: UIScrollView? {
        
        if let bannerOver = self as? ADBannerOverScrollView {
       
            return bannerOver.scrollViewBehindOfBanner()
        }
        
        return nil
    }
    
    
    public func bannerViewDidLoadAd(banner: ADBannerView!){
        
        UIView.animateWithDuration(0.5) {
            
            let iADBannerHeight = banner.frame.height
            banner.alpha = 1
            self.viewBehind?.contentInset = UIEdgeInsetsMake(0, 0, iADBannerHeight, 0);
        }
    }
    
    public func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!){
        
        UIView.animateWithDuration(0.5) {
            
            banner.alpha = 0
            self.viewBehind?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }
    
}

@objc protocol ADBannerOverScrollView {
    
    func scrollViewBehindOfBanner() -> UIScrollView
    
}

extension Array {
    
    func maxItems(max: Int) -> Array {
        
        if(self.count < max){
            
            return self
        }
        
        return Array(self[0..<max])
    }

}

extension UIWebView {
    
    var title: String {
        
        get{
            
            return self.stringByEvaluatingJavaScriptFromString("document.title")!
        }
        
    }
}
