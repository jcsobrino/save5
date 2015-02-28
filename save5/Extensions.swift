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
