//
//  Utils.swift
//  save5
//
//  Created by José Carlos Sobrino on 01/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class Utils: NSObject {

    
    class func formatSeconds (totalSeconds:Int) -> String {
        
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        let hours = totalSeconds / 3600
        
        if(hours > 0){
            
            return NSString(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        
        return NSString(format:"%02d:%02d", minutes, seconds)
    }
    
    class func localizedString(key: String, var arguments: [CVarArgType]) -> String {
        
        return String(format: NSLocalizedString(key, comment: ""), arguments: arguments)
    }
    
    class func localizedString(key: String) -> String {
        
        return String(format: NSLocalizedString(key, comment: ""))
    }
    
    class func generateUUID() -> String {
        
        return NSUUID().UUIDString.stringByReplacingOccurrencesOfString("-", withString: "", options: .LiteralSearch, range: nil)
    }
    
}
