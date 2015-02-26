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
    
    private var downloads:[DownloadTask] = []
    private let syncronizedQueue = dispatch_queue_create("SyncronizedQuery", nil)
    private var sessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.js.save5")
    private var session:NSURLSession?
    
    struct notification {
        
        static let newDownload = "NewDownload"
        static let updateDownload = "UpdateDownload"
        static let finishDownload = "FinishDownload"
    }
    
    class var sharedInstance : DownloadManager {
        
        struct Static {
            static let instance : DownloadManager = DownloadManager()
        }
        return Static.instance
    }
    
    var iteratorTask: IndexingGenerator<Array<DownloadTask>> {
        
        get {
            return downloads.generate()
        }
    }

    
    private override init() {
        
        super.init()
        downloads.generate()
        session = NSURLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
    }
    
    func countDownloadTask()-> Int {
        
        var count = 0
        
        //dispatch_sync(syncronizedQuery){
            
            count = self.downloads.count
        //}
        
        return count
        
    }
    
    func getDownloadTaskAtIndex(index: Int) -> DownloadTask{
       
        var downloadTask: DownloadTask?
        
        //dispatch_sync(syncronizedQuery){
        
            downloadTask = self.downloads[index]
        //}
        
        return downloadTask!
    }
    
    func downloadVideo(videoURL:NSURL, name:String, sourcePage:String, folder:Folder?){
        
        println(videoURL)
        
        let video = VideoVO()
        video.videoURL = videoURL
        video.name = name
        video.sourcePage = sourcePage
        video.folder = folder
        
        let sourceAsset = AVURLAsset(URL: video.videoURL, options: nil)
        video.length = Int64(CMTimeGetSeconds(sourceAsset.duration))
        
        let downloadTask = DownloadTask(video: video)
        downloadTask.downloadTask = session!.downloadTaskWithURL(video.videoURL!)
        downloadTask.downloadTask!.resume()
    
       dispatch_sync(syncronizedQueue){
        
            self.downloads.append(downloadTask)
            NSNotificationCenter.defaultCenter().postNotificationName(notification.newDownload, object: self.downloads.count)
        }
    }
 
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        
        dispatch_sync(syncronizedQueue) {
            
            if let index = self.getIndexDownloadTask(downloadTask) {
                
                self.downloads[index].numOfReadBytes = totalBytesWritten
                self.downloads[index].numOfExpectedBytes = totalBytesExpectedToWrite
                
                NSNotificationCenter.defaultCenter().postNotificationName(notification.updateDownload, object: index)
            }
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL){
        
        let sessionDownloadTask = downloadTask
        
        dispatch_sync(syncronizedQueue){
        
            if let index = self.getIndexDownloadTask(sessionDownloadTask) {
                
                let downloadTask = self.downloads[index]
                let videoVO = downloadTask.video
                
                downloadTask.numOfReadBytes = sessionDownloadTask.countOfBytesReceived
                downloadTask.numOfExpectedBytes = sessionDownloadTask.countOfBytesExpectedToReceive
                videoVO.id = Utils.generateUUID()
                videoVO.spaceOnDisk = self.downloads[index].numOfExpectedBytes
                
                let videoFilenameAbsolute = Utils.utils.documentsPath.stringByAppendingPathComponent("\(videoVO.id!).mp4") //mp4??
                videoVO.videoFilename = videoFilenameAbsolute.lastPathComponent
                let videoURL = NSURL(fileURLWithPath: videoFilenameAbsolute)!
                
                NSFileManager.defaultManager().copyItemAtURL(location, toURL: videoURL, error: nil)
                
                let thumbnail = Utils.generateVideoThumbnail(videoURL, videoLength: videoVO.length!)
                let thumbnailFilenameAbsolute = Utils.utils.documentsPath.stringByAppendingPathComponent("\(videoVO.id!).png")
                videoVO.thumbnailFilename = thumbnailFilenameAbsolute.lastPathComponent
                
                thumbnail.writeToFile(thumbnailFilenameAbsolute, atomically: true)
                
                VideoDAO.sharedInstance.createVideo(videoVO)
                NSNotificationCenter.defaultCenter().postNotificationName(notification.updateDownload, object: index)
                
                self.downloadFinishedLocalNotification(downloadTask)
                
                NSNotificationCenter.defaultCenter().postNotificationName(notification.finishDownload, object: index)
            }
        }
        
    }
    
    func clearDownloadTask(index: Int){
        
        dispatch_sync(syncronizedQueue) {
        
            let downloadTask = self.downloads[index]
        
            if (!downloadTask.isCompleted()) {
            
                downloadTask.cancelDownload()
            }
            
            self.downloads.removeAtIndex(index)
            
            println("\(self.downloads.count) tasks left")
        }
    }
    
    
    func pauseDownloadTask(index: Int){
        
        dispatch_sync(syncronizedQueue) {
        
            let downloadTask = self.downloads[index]
            downloadTask.pauseDownload()
        
            NSNotificationCenter.defaultCenter().postNotificationName(notification.updateDownload, object: index)
        }
    }
    
    func resumeDownloadTask(index: Int){
        
        dispatch_sync(syncronizedQueue) {
        
            let downloadTask = self.downloads[index]
            downloadTask.resumeDownload()
        
            NSNotificationCenter.defaultCenter().postNotificationName(notification.updateDownload, object: index)
        }
    }
    
    private func getIndexDownloadTask(downloadTask:NSURLSessionDownloadTask) -> Int? {
        
        for (index, value) in enumerate(downloads) {
            
            if (value.downloadTask == downloadTask) {
                
                return index
            }
        }
        return nil
    }
    
    private func downloadFinishedLocalNotification(downloadTask: DownloadTask){
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = NSDate()
        localNotification.alertBody = String(format: "%@ has been downloaded successfully!", downloadTask.video.name!)
        localNotification.alertAction = Utils.localizedString("play this video")
        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
    }
}
