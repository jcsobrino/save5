//
//  DownloadManager.swift
//  save5
//
//  Created by José Carlos Sobrino on 31/01/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit
import AVFoundation

class DownloadManager: NSObject, NSURLSessionDownloadDelegate {
    
    var downloads:[DownloadTask] = []
    private var sessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.js.save5")
    private var session:NSURLSession?
    private let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    
    struct notification {
        
        static let newDownload = "NewDownload"
        static let updateDownload = "UpdateDownload"
        static let finishDownload = "FinishDownload"
    }
    
    class var sharedInstance: DownloadManager {
        struct Static {
            static var instance: DownloadManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = DownloadManager()
        }
        
        return Static.instance!
    }
    
    override init() {
        
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "clearDownload:", name:"ClearDownload", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "restartDownload:", name:"RestartDownload", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "settingsChanged:", name:"kAppSettingChanged", object: nil)
        
        session = NSURLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
    }
    
    func downloadVideo(videoURL:NSURL, name:String){
        
        let video = VideoVO()
        video.videoURL = videoURL
        video.name = name
        
        let sourceAsset = AVURLAsset(URL: video.videoURL, options: nil)
        video.length = Int64(CMTimeGetSeconds(sourceAsset.duration))
        
        let downloadTask = DownloadTask(video: video)
        downloadTask.downloadTask = session!.downloadTaskWithURL(video.videoURL!)
        downloadTask.downloadTask!.resume()
        downloads.append(downloadTask)
        
        NSNotificationCenter.defaultCenter().postNotificationName(notification.newDownload, object: downloadTask)
    }
    
    func listDownloads() -> [DownloadTask]{
        
        return downloads
    }
    
    func removeDownload(notification:NSNotification){
        
        let downloadTaskToClear = notification.object as DownloadTask
        let index = (downloads as NSArray).indexOfObject(downloadTaskToClear)
        downloads.removeAtIndex(index)
    }
    
    func restartDownload(notification:NSNotification){
        
        let downloadTaskToRestart = notification.object! as DownloadTask
        let index = (downloads as NSArray).indexOfObject(downloadTaskToRestart)
        
      //  downloadTaskToRestart.clearTask()
      //  addVideoStreamToDownload(downloadTaskToRestart.video)
    }
    
    /* Sent periodically to notify the delegate of download progress. */
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        
        Async.background {
            
            if let index = self.getBackgroundDownloadTaskIndex(downloadTask) {
                
                self.downloads[index].numOfReadBytes = totalBytesWritten
                self.downloads[index].numOfExpectedBytes = totalBytesExpectedToWrite
                
                NSNotificationCenter.defaultCenter().postNotificationName(notification.updateDownload, object: index)
            }
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL){
        
        if let index = self.getBackgroundDownloadTaskIndex(downloadTask) {
            
            let videoId = NSUUID().UUIDString.stringByReplacingOccurrencesOfString("-", withString: "", options: .LiteralSearch, range: nil)
            let backTask = downloads[index]
            
            let imageToSaveFilename = documentsPath.stringByAppendingPathComponent(videoId+"."+backTask.video.thumbnailFilename!.lastPathComponent.pathExtension)
          //  NSData(contentsOfURL: backTask.video.thumbnailFilename)!.writeToFile(imageToSaveFilename, atomically: true)
            
            let videoToSaveFilename = documentsPath.stringByAppendingPathComponent("\(videoId).mp4")
            NSFileManager.defaultManager().copyItemAtURL(location, toURL: NSURL(fileURLWithPath: videoToSaveFilename)!, error: nil)
            
            backTask.videoFilename = videoToSaveFilename.lastPathComponent
            
/*            let error = VideoDAO.sharedInstance.saveVideo(backTask.video.id,  name: backTask.video.name, filename: videoToSaveFilename.lastPathComponent, thumbnailFilename: imageToSaveFilename.lastPathComponent, type: "\(backTask.videoStream.streamId)", downloadDate: NSDate(), spaceOnDisk: backTask.numOfExpectedBytes, length: backTask.video.length)
  */          
            self.downloads[index].numOfReadBytes = downloadTask.countOfBytesReceived
            self.downloads[index].numOfExpectedBytes = downloadTask.countOfBytesExpectedToReceive
            
            NSNotificationCenter.defaultCenter().postNotificationName(notification.finishDownload, object: index)
            endDownloadLocalNotification(backTask)
        }
        
    }
    
    func clearDownloadTask(index:Int){
        
        let taskToClear = downloads[index]
        
        if (!taskToClear.isCompleted()) {
            
            taskToClear.cancelDownload()
        }
        
        downloads.removeAtIndex(index)
    }
    
    func clearDownloadTask(downloadTask:DownloadTask){
        
        let index = (downloads as NSArray).indexOfObject(downloadTask)
        clearDownloadTask(index)
    }
    
    func getBackgroundDownloadTaskIndex(downloadTask:NSURLSessionDownloadTask) -> Int? {
        
        for (index, value) in enumerate(downloads) {
            
            if (value.downloadTask == downloadTask) {
                
                return index
            }
        }
        return nil
    }
    
    func endDownloadLocalNotification(downloadTask: DownloadTask){
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = NSDate()
        //localNotification.alertBody = Utils.localizedString("%@ has been downloaded successfully!", arguments: [downloadTask.video.name])
        //localNotification.alertAction = Utils.localizedString("play this video")
        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
    }
   
}
