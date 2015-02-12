//
//  Extensions.swift
//  save5
//
//  Created by José Carlos Sobrino on 12/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar{
    
    struct icons {
        
        static let reload =  FAKFontAwesome.refreshIconWithSize(10.0).imageWithSize(CGSize(width: 10.0, height: 10.0))
    }
    
    struct states {
    
        static let empty = 0
        static let stopLoading = 1
        static let cancelLoading = 2
    }
    
    var state:Int {
        
        get {
            return self.state
        }
        
        
        
    }
    struct xx{
     
        var state = states.empty
    }
    
    func showStopLoadingButton() {
        
        showsBookmarkButton = true
        setImage(icons.reload, forSearchBarIcon: UISearchBarIcon.Bookmark, state: UIControlState.Normal)
    
    }
}