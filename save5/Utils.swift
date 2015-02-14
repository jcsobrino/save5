//
//  Utils.swift
//  save5
//
//  Created by José Carlos Sobrino on 01/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class Utils: NSObject {

    struct utils {
        
        static let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    }
    
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
    
    class func isValidURL(var testString:String) -> Bool {
        
        var error: NSError?
        let pattern = "^(http(?:s)?\\:\\/\\/[a-zA-Z0-9\\-]+(?:\\.[a-zA-Z0-9\\-]+)*\\.[a-zA-Z]{2,6}(?:\\/?|(?:\\/[\\w\\-]+)*)(?:\\/?|\\/\\w+\\.[a-zA-Z]{2,4}(?:\\?[\\w]+\\=[\\w\\-]+)?)?(?:\\&[\\w]+\\=[\\w\\-]+)*)$"
        
        let internalExpression = NSRegularExpression(pattern: pattern, options: .CaseInsensitive, error: &error)!
        let matches = internalExpression.matchesInString(testString, options: nil, range:NSMakeRange(0, countElements(testString)))
      
        return matches.count > 0
    }
    
    class func mergeImages(images:[UIImage]) -> UIImage {
        
        let newSize = CGSizeMake(200, 140)
        let numImages = images.count
        
        UIGraphicsBeginImageContext(newSize)
        
        var context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 3.0)
        
        for (index, image) in enumerate(images) {
            
            var height = newSize.height / CGFloat(numImages)
            
            image.drawInRect(CGRectMake(0, CGFloat(index) * height, newSize.width, height))
            
            if(index < numImages-1) {
                
                CGContextMoveToPoint(context, 0, CGFloat(index+1) * height);
                CGContextAddLineToPoint(context, newSize.width, CGFloat(index+1) * height);
                CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor);
                CGContextStrokePath(context);
            }
        }
        
        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
