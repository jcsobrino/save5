//
//  BlockedSitesManager.swift
//  save5
//
//  Created by José Carlos Sobrino on 19/03/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import Foundation


class BlockedSitesManager: NSObject {

    
    private let blockedSitesActive = true
    private let blockedSites:NSArray!
    
    class var sharedInstance : BlockedSitesManager {
        
        struct Static {
            static let instance : BlockedSitesManager = BlockedSitesManager()
        }
        return Static.instance
    }
    
    
    private override init() {
        
        super.init()
        
        var dictionary = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("ProtectedSites", ofType: "plist")!)
        blockedSites = dictionary?.objectForKey("Sites") as NSArray
    }

    
    func isAllowedSite(URL:NSURL) -> Bool {
        
        if(!blockedSitesActive) {
            
            return true
        }
        
        let host = URL.host!
        
        for site in blockedSites {
            
            let regextest = NSPredicate(format: "SELF MATCHES %@", argumentArray: [site])
            
            if(regextest.evaluateWithObject(host)){
                
                return false
            }
        }
        
        return true
    }
    

}