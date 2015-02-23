//
//  WebRecentSearchesManager.swift
//  save5
//
//  Created by José Carlos Sobrino on 23/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class WebRecentSearchesManager: NSObject {
   
    class var sharedInstance : WebRecentSearchesManager {
        
        struct Static {
            static let instance : WebRecentSearchesManager = WebRecentSearchesManager()
        }
        return Static.instance
    }
    
    private override init(){
        
    }
    
    func addItem(URL: String, title: String) {
    
        WebRecentSearchItemDAO.sharedInstance.addItem(URL, title: title)
    }
    
    func findItems(string: String) -> [WebRecentSearchItem]{
     
        return WebRecentSearchItemDAO.sharedInstance.findItems(string)
    }
    
    func clear(){
        
    }
}
