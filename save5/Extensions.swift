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
    
    func initIcons(){
        
        self.setImage(LookAndFeel.icons.searchIcon, forSearchBarIcon: .Search, state: .Normal)
        self.setImage(LookAndFeel.icons.clearIcon, forSearchBarIcon: .Clear, state: .Normal)
        

        
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

extension UITableViewController {
    
    func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath){
        tableView.scrollEnabled = false
    }
    
    func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath){
        tableView.scrollEnabled = true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
}

extension UIViewController {

    public func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }

}





func arc4random <T: IntegerLiteralConvertible> (type: T.Type) -> T {
    var r: T = 0
    arc4random_buf(&r, UInt(sizeof(T)))
    return r
}


extension UInt64 {
    static func random(lower: UInt64 = min, upper: UInt64 = max) -> UInt64 {
        var m: UInt64
        let u = upper - lower
        var r = arc4random(UInt64)
        
        if u > UInt64(Int64.max) {
            m = 1 + ~u
        } else {
            m = ((max - (u * 2)) + 1) % u
        }
        
        while r < m {
            r = arc4random(UInt64)
        }
        
        return (r % u) + lower
    }
}


extension Int64 {
    static func random(lower: Int64 = min, upper: Int64 = max) -> Int64 {
        let (s, overflow) = Int64.subtractWithOverflow(upper, lower)
        let u = overflow ? UInt64.max - UInt64(~s) : UInt64(s)
        let r = UInt64.random(upper: u)
        
        if r > UInt64(Int64.max)  {
            return Int64(r - (UInt64(~lower) + 1))
        } else {
            return Int64(r) + lower
        }
    }
}

