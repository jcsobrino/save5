//
//  ActiveDownloadsViewController.swift
//  save5
//
//  Created by José Carlos Sobrino on 31/01/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class ActiveDownloadsViewController: UITableViewController, DZNEmptyDataSetSource {
    
    var clearCompletedDownloadsButton: UIBarButtonItem!
    var cancelActiveDownloadsButton: UIBarButtonItem!
    
    let cellIndentifier = "ActiveDownloadTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        
        self.title = Utils.localizedString("Downloads")
        
        clearCompletedDownloadsButton = UIBarButtonItem(title: Utils.localizedString("Clear"), style: .Plain, target: self, action: "clearCompletedDownloadsButtonClicked")
        cancelActiveDownloadsButton = UIBarButtonItem(title: Utils.localizedString("Cancel"), style: .Plain, target: self, action: "cancelActiveDownloadsButtonClicked")
        
        self.navigationItem.setLeftBarButtonItem(clearCompletedDownloadsButton, animated: true)
        self.navigationItem.setRightBarButtonItem(cancelActiveDownloadsButton, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       
        return DownloadManager.sharedInstance.countDownloadTask()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier, forIndexPath: indexPath) as ActiveDownloadTableViewCell
        
        configureCell(cell, indexPath: indexPath)
       
        return cell
    }
    
    func configureCell(cell:ActiveDownloadTableViewCell, indexPath:NSIndexPath){
        
        let downloadTask = DownloadManager.sharedInstance.getDownloadTaskAtIndex(indexPath.row)
        
        cell.name.text = downloadTask.video.name
        cell.hostname.text = NSURL(string: downloadTask.video.sourcePage!)?.host
        cell.ETA.text = Utils.localizedString("%@ of %@ downloaded.", arguments: [Utils.prettyLengthFile(downloadTask.numOfReadBytes), Utils.prettyLengthFile(downloadTask.numOfExpectedBytes)])
        cell.circularProgress!.progress = CGFloat(downloadTask.progress)
        cell.circularProgress!.progressLabel.text = String(format:"%.0f%%", downloadTask.progress*100.0)
        
        if(downloadTask.isCompleted()) {
            
            cell.remainingTime.text = Utils.localizedString("Completed!")
            cell.remainingTime.textColor = LookAndFeel.style.progressStatusColor
            
        } else if(downloadTask.isSuspended()) {
            
            cell.remainingTime.text = Utils.localizedString("Pause")
            cell.remainingTime.textColor = LookAndFeel.style.progressStatusColor
            
        } else {
           
            cell.remainingTime.text = downloadTask.remainingSeconds != nil ? Utils.formatSeconds(downloadTask.remainingSeconds!) : Utils.localizedString("Starting...")
            cell.remainingTime.textColor = LookAndFeel.style.subtitleMiniCellColor
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        
        let indexSelected = tableView.indexPathForSelectedRow()?.row
        let downloadTask = DownloadManager.sharedInstance.getDownloadTaskAtIndex(indexSelected!)
            
        return downloadTask.isCompleted()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let indexSelected = tableView.indexPathForSelectedRow()?.row
        let downloadTask = DownloadManager.sharedInstance.getDownloadTaskAtIndex(indexSelected!)
        
        if(downloadTask.isCompleted()){
            
            let playerViewController = segue.destinationViewController as PlayerViewController
            let videoFilenameAbsolute = Utils.utils.documentsPath.stringByAppendingPathComponent(downloadTask.video.videoFilename!)
            playerViewController.file = videoFilenameAbsolute
        }
    }

    
    func titleForEmptyDataSet(scrollView:UIScrollView) -> NSAttributedString {
        
        let message = Utils.localizedString("No active downloads")
        return NSAttributedString(string: message, attributes: LookAndFeel.style.titleEmptyViewAttributes)
    }
    
    func imageForEmptyDataSet(scrollView:UIScrollView) -> UIImage {
        
        return LookAndFeel.icons.noActiveDownloadsIcon
    }
    
    func spaceHeightForEmptyDataSet(scrollView:UIScrollView) -> CGFloat {
        
        return LookAndFeel.style.spaceHeightForEmptyDataSet
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        Async.main{
        
             self.tableView.reloadData()
        
        }.background {
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateDownloadTask:", name:DownloadManager.notification.updateDownload, object: nil)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:DownloadManager.notification.updateDownload, object: nil)
    }
    
    func updateDownloadTask(notification: NSNotification){
        
        let indexPath = NSIndexPath(forRow: notification.object as Int, inSection: 0)
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ActiveDownloadTableViewCell {
            
            Async.main {
            
                self.configureCell(cell, indexPath: indexPath)
            }
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject] {
        
        let downloadTask = DownloadManager.sharedInstance.getDownloadTaskAtIndex(indexPath.row)
        var actions:[AnyObject] = []
        
        if (downloadTask.isCompleted()) {
            
            let clearAction = UITableViewRowAction(style: .Default, title: Utils.localizedString("Clear")) { (action, indexPath) -> Void in
                
                self.tableView.beginUpdates()
                DownloadManager.sharedInstance.clearDownloadTask(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths( [indexPath], withRowAnimation: .Fade)
                self.tableView.endUpdates()
            }
            
            clearAction.backgroundColor = LookAndFeel.style.blueAction
            actions.append(clearAction)
            
        } else {
            
            if(downloadTask.isExecuting()){
                
                let restartAction = UITableViewRowAction(style: .Normal, title: Utils.localizedString("Pause")) { (action, indexPath) -> Void in
                    
                    tableView.editing = false
                    DownloadManager.sharedInstance.pauseDownloadTask(indexPath.row)
                }
                
                restartAction.backgroundColor = LookAndFeel.style.yellowAction
                actions.append(restartAction)
                
                
            } else if (downloadTask.isSuspended()){
                
                let restartAction = UITableViewRowAction(style: .Normal, title: Utils.localizedString("Resume")) { (action, indexPath) -> Void in
                    
                    tableView.editing = false
                    DownloadManager.sharedInstance.resumeDownloadTask(indexPath.row)
                }
                
                restartAction.backgroundColor = LookAndFeel.style.greenAction
                actions.append(restartAction)
                
            }
            
            let cancelAction = UITableViewRowAction(style: .Default, title: Utils.localizedString("Cancel")) { (action, indexPath) -> Void in
                
                tableView.editing = false
                
                let alert = UIAlertController(title: Utils.localizedString("Confirm action"), message: Utils.localizedString("Do you really want to cancel this process?"), preferredStyle: .Alert)
                
                alert.addAction(UIAlertAction(title: Utils.localizedString("No"), style: .Cancel, handler: nil))
                alert.addAction(UIAlertAction(title: Utils.localizedString("Yes"), style: .Destructive) { _ in
                   
                    self.tableView.beginUpdates()
                    DownloadManager.sharedInstance.clearDownloadTask(indexPath.row)
                    self.tableView.deleteRowsAtIndexPaths( [indexPath], withRowAnimation: .Fade)
                    self.tableView.endUpdates()
                })
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            cancelAction.backgroundColor = LookAndFeel.style.redAction
            actions.append(cancelAction)
            
        }
        
        return actions
    }
    
    @IBAction func clearCompletedDownloadsButtonClicked(){
       
        var iterator = DownloadManager.sharedInstance.iteratorTask
        var index = 0
    
        while let elto = iterator.next() {
            
            if(elto as DownloadTask).isCompleted(){
                
                self.tableView.beginUpdates()
                DownloadManager.sharedInstance.clearDownloadTask(index)
                self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Fade)
                self.tableView.endUpdates()
            }
        }
            
    }
    
    @IBAction func cancelActiveDownloadsButtonClicked(){
        
        let alert = UIAlertController(title: Utils.localizedString("Confirm action"), message: Utils.localizedString("Do you really want to cancel all active downloads?"), preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: Utils.localizedString("No"), style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: Utils.localizedString("Yes"), style: .Destructive) { _ in
            
            var iterator = DownloadManager.sharedInstance.iteratorTask
            var index = 0
            
            while let elto = iterator.next() {
                
                if !(elto as DownloadTask).isCompleted(){
                    
                    self.tableView.beginUpdates()
                    DownloadManager.sharedInstance.clearDownloadTask(index)
                    self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Fade)
                    self.tableView.endUpdates()
                }
            }
            
        })
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

}
