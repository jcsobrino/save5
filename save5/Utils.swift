//
//  Utils.swift
//  save5
//
//  Created by José Carlos Sobrino on 01/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit
import AVFoundation

class Utils: NSObject {

    struct utils {
        
        static let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        static let URLRegularExpression = _URLRegularExpression
    }
    
    private class var _URLRegularExpression: NSRegularExpression {
    
        var error: NSError?
        let pattern = "^(?:(?:https?):\\/\\/)(?:\\S+(?::\\S*)?@)?(?:(?!10(?:\\.\\d{1,3}){3})(?!127(?:\\.\\d{1,3}){3})(?!169\\.254(?:\\.\\d{1,3}){2})(?!192\\.168(?:\\.\\d{1,3}){2})(?!172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2})(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-z\\xa1-\\xff0-9]+-?)*[a-z\\xa1-\\xff0-9]+)(?:\\.(?:[a-z\\xa1-\\xff0-9]+-?)*[a-z\\xa1-\\xff0-9]+)*(?:\\.(?:[a-z\\xa1-\\xff]{2,})))(?::\\d{2,5})?(?:\\/[^\\s]*)?$"
        
        let internalExpression = NSRegularExpression(pattern: pattern, options: .CaseInsensitive, error: &error)!
        
        if(error != nil){
            
            log.error("Error creating URL regular expresion: \(error)")
        }
        
        return internalExpression
        
    }
    
    private override init(){
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
        
        return utils.URLRegularExpression.matchesInString(testString, options: nil, range:NSMakeRange(0, countElements(testString))).count > 0
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
    
    class func createMutableAttributedString(icon: NSAttributedString, text: String) -> NSMutableAttributedString {
       
        let mutableAttributeString = NSMutableAttributedString(attributedString: icon)
        
       // mutableAttributeString.appendAttributedString(NSAttributedString(string: " "))
    
        mutableAttributeString.appendAttributedString(NSAttributedString(string: text))
       
        mutableAttributeString.addAttribute(NSBaselineOffsetAttributeName, value: 4, range: NSMakeRange(1, countElements(text)))
        
        return mutableAttributeString
    }
    
    class func generateVideoThumbnail(videoURL: NSURL, videoLength: Int64) ->  NSData {
        
        let asset = AVAsset.assetWithURL(videoURL) as AVURLAsset
        let generator = AVAssetImageGenerator(asset: asset)
        let time = CMTimeMake(Int64.random (lower: 1, upper: videoLength), 1)
        var err:NSError?
        let imgRef = generator.copyCGImageAtTime(time, actualTime: nil, error: &err)
        let thumbnail = UIImage(CGImage: imgRef)
        
        return UIImagePNGRepresentation(thumbnail)
    }
    
    class func prettyLengthFile(bytes: Int64) -> String {
        
        let KB = Float(bytes) / 1024.0
        
        if(KB < 1024) {
            
            return String(format: "%.2f KB", KB)
        }
        
        let MB = KB / 1024.0
        
        if(MB < 1024) {
            
            return String(format: "%.2f MB", MB)
        }
        
        return String(format: "%.2f GB", MB / 1024.0)
    }
    
}
