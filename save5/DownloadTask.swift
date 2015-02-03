//
//  DownloadTask.swift
//  save5
//
//  Created by José Carlos Sobrino on 31/01/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class DownloadTask: NSObject {
   
    let smoothFactor:Double = 0.2
    
    let video:VideoVO
    var videoFilename:String?
    var downloadTask:NSURLSessionDownloadTask?
    var numOfReadBytes:Int64 = 0
    var numOfExpectedBytes:Int64 = 0
    let startTime = NSDate()
    var averageSpeed:Double = 0
    
    init(video:VideoVO){
        
        self.video = video
        
        super.init()
    }
    
    
    func isCompleted() -> Bool {
        
        return downloadTask != nil ? downloadTask!.state == .Completed : false
    }
    
    func isSuspended() -> Bool {
        
        return downloadTask != nil ? downloadTask!.state == .Suspended : false
    }
    
    func isExecuting() -> Bool {
        
        return downloadTask != nil ? downloadTask!.state == .Running : false
    }
    
    func cancelDownload(){
        
        downloadTask?.cancel()
    }
    
    func pauseDownload(){
        
        downloadTask?.suspend()
    }
    
    func resumeDownload(){
        
        downloadTask?.resume()
    }
    
    var progress:Float {
       
        get {
        
            return numOfExpectedBytes > 0 ? Float(numOfReadBytes)/Float(numOfExpectedBytes) : Float(0)
        }
    }
    
    var remainingSeconds:Int {
        
        get {
            
            let seconds = -startTime.timeIntervalSinceNow
            let speed = Double(numOfReadBytes) / seconds
            averageSpeed = smoothFactor * speed + (1 - smoothFactor) * averageSpeed
            
            if(averageSpeed > 0) {
                
                return Int(Double(numOfExpectedBytes) * Double(1 - progress) / averageSpeed)
            }
            
            return -1
        }
        
    }
}
