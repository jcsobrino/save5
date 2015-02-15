//
//  ActiveDownloadsViewController.swift
//  save5
//
//  Created by José Carlos Sobrino on 31/01/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class ActiveDownloadsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource {

    let downloadManager = DownloadManager.sharedInstance
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearCompletedDownloadsButton: UIBarButtonItem!
    @IBOutlet weak var cancelActiveDownloadsButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.emptyDataSetSource = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        self.title = "Downloads"        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       
        return downloadManager.downloads.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIndentifier = "ActiveDownloadTableViewCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier, forIndexPath: indexPath) as ActiveDownloadTableViewCell
        
        configureCell(cell, indexPath: indexPath)
       
        return cell
    }
    
    func configureCell(cell:ActiveDownloadTableViewCell, indexPath:NSIndexPath){
        
        let downloadTask = downloadManager.downloads[indexPath.row]
        
        cell.name.text = downloadTask.video.name
        cell.hostname.text = NSURL(string: downloadTask.video.sourcePage!)?.host
        
        cell.ETA.text = String(format: "%.2f of %.2f MBs downloaded.", Float(downloadTask.numOfReadBytes)/1048576.0, Float(downloadTask.numOfExpectedBytes)/1048576.0)
       
        cell.circularProgress!.progress = CGFloat(downloadTask.progress)
        cell.circularProgress!.progressLabel.text = String(format:"%.0f%%",downloadTask.progress*100.0)
        
        
        if(downloadTask.isCompleted()){
            
            cell.remainingTime.text = "Completed!"
            cell.remainingTime.textColor = LookAndFeel.style.mainColor
            
        } else if(downloadTask.isSuspended()){
            
            cell.remainingTime.text = "Pause"
            cell.remainingTime.textColor = LookAndFeel.style.mainColor
            
        }else {
           
            cell.remainingTime.text = Utils.formatSeconds(downloadTask.remainingSeconds)
            cell.remainingTime.textColor = LookAndFeel.style.subtitleMiniCellColor
        }
        
    }
    
    func titleForEmptyDataSet(scrollView:UIScrollView) -> NSAttributedString {
        
        let message = Utils.localizedString("No active downloads")
        return NSAttributedString(string: message, attributes: LookAndFeel.style.titleEmptyViewAttributes)
    }
    
    func descriptionForEmptyDataSet(scrollView:UIScrollView) -> NSAttributedString {
        
        let message = Utils.localizedString("There are not videos downloading at this moment")
        return NSAttributedString(string: message, attributes: LookAndFeel.style.descriptionEmptyViewAttributes)
    }
    
    func imageForEmptyDataSet(scrollView:UIScrollView) -> UIImage {
        
        return UIImage(named: "download-empty-state.png")!.imageByApplyingAlpha(0.5)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateDownloadTask:", name:DownloadManager.notification.updateDownload, object: nil)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:DownloadManager.notification.updateDownload, object: nil)
    }
    
    func updateDownloadTask(notification: NSNotification){
        
        let indexPath = NSIndexPath(forRow: notification.object as Int, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? ActiveDownloadTableViewCell
        
        if(cell != nil){
            
            Async.main {
            
                self.configureCell(cell!, indexPath: indexPath)
            }
        }
    }
    
    func tableView(tableView: UITableView!, editActionsForRowAtIndexPath indexPath: NSIndexPath!) -> [AnyObject] {
        
        let downloadTask = downloadManager.downloads[indexPath.row]
        var actions:[AnyObject] = []
        
        if (downloadTask.isCompleted()) {
            
            let clearAction = UITableViewRowAction(style: .Default, title: Utils.localizedString("Clear")) { (action, indexPath) -> Void in
                
                self.tableView.beginUpdates()
                self.downloadManager.clearDownloadTask(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths( [indexPath], withRowAnimation: .Fade)
                self.tableView.endUpdates()
            }
            
            clearAction.backgroundColor = LookAndFeel.style.blueAction
            actions.append(clearAction)
            
        } else {
            
            if(downloadTask.isExecuting()){
                
                let restartAction = UITableViewRowAction(style: .Normal, title: Utils.localizedString("Pause")) { (action, indexPath) -> Void in
                    
                    tableView.editing = false
                    self.downloadManager.pauseDownloadTask(indexPath.row)
                }
                
                restartAction.backgroundColor = LookAndFeel.style.pinkAction
                actions.append(restartAction)
                
                
            } else if (downloadTask.isSuspended()){
                
                let restartAction = UITableViewRowAction(style: .Normal, title: Utils.localizedString("Resume")) { (action, indexPath) -> Void in
                    
                    tableView.editing = false
                    self.downloadManager.resumeDownloadTask(indexPath.row)
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
                    self.downloadManager.clearDownloadTask(indexPath.row)
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
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
    }
    
    
}
