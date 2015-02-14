//
//  SearchVideosTableViewController.swift
//  save5
//
//  Created by José Carlos Sobrino on 10/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//


import CoreData

class SearchVideosTableViewController: UITableViewController, DZNEmptyDataSetSource {

    let cellIndentifier = "SearchVideoTableViewCell"
    var data = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.estimatedRowHeight = 90
        tableView.emptyDataSetSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        self.title = "Search"
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier, forIndexPath: indexPath) as VideoTableViewCell
        
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell:VideoTableViewCell, indexPath:NSIndexPath){
        
        Async.main {
            
            let video = self.data[indexPath.row] as Video
            let pathFile = Utils.utils.documentsPath.stringByAppendingPathComponent(video.thumbnailFilename)
            
            cell.name.text = video.name
            cell.hostname.text = NSURL(string: video.sourcePage)?.host
            cell.size.text = String(format: "%.2f MB", video.spaceOnDisk/1024)
            cell.length.text = Utils.formatSeconds(Int(video.length))
            cell.thumbnail.image = UIImage(contentsOfFile: pathFile)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let indexPath = tableView.indexPathForSelectedRow()
        let video = self.data[indexPath!.row] as Video
        let playerViewController = segue.destinationViewController as PlayerViewController
        let videoFilenameAbsolute = Utils.utils.documentsPath.stringByAppendingPathComponent(video.videoFilename)
        
        playerViewController.file = videoFilenameAbsolute
    }


    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        data = VideoDAO.sharedInstance.findByName(searchController.searchBar.text, sortDescriptor: nil)
        tableView!.reloadData()
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject] {
        
        var deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { (action, indexPath) -> Void in
            
            tableView.editing = false
            let video = self.data[indexPath.row] as Video
            
            var alert = UIAlertController(title: Utils.localizedString("Confirm action"), message: Utils.localizedString("Do you really want to delete this item?"), preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: Utils.localizedString("No"), style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: Utils.localizedString("Yes"), style: .Destructive) { (action) in
                
                let fileManager = NSFileManager.defaultManager()
                let pathFileVideo = Utils.utils.documentsPath.stringByAppendingPathComponent(video.videoFilename)
                let pathFileThumbnail = Utils.utils.documentsPath.stringByAppendingPathComponent(video.thumbnailFilename)
                fileManager.removeItemAtPath(pathFileThumbnail, error: nil)
                fileManager.removeItemAtPath(pathFileVideo, error: nil)
                VideoDAO.sharedInstance.deleteObject(video)
                })
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        var moveToFolderAction = UITableViewRowAction(style: .Default, title: "Move") { (action, indexPath) -> Void in
            
            tableView.editing = false
            let video = self.data[indexPath.row] as Video
            
            let actionSheet =  UIAlertController(title: Utils.localizedString("Select folder to move"), message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let folders = FolderDAO.sharedInstance.findAll() as [Folder]
            
            for folder in folders  {
                
                if(folder != video.folder){
                    
                    actionSheet.addAction(UIAlertAction(title: folder.name, style: UIAlertActionStyle.Default, handler: { (ACTION :UIAlertAction!)in
                        
                        video.folder = folder
                    }))
                }
            }
            
            actionSheet.addAction(UIAlertAction(title: Utils.localizedString("Cancel"), style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
        
        moveToFolderAction.backgroundColor = LookAndFeel.style.greenApple
        
        return [moveToFolderAction, deleteAction]
    }

    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func titleForEmptyDataSet(scrollView:UIScrollView) -> NSAttributedString {
        
        let message = Utils.localizedString("No videos found")
        return NSAttributedString(string: message, attributes: LookAndFeel.style.titleEmptyViewAttributes)
    }
    
    func descriptionForEmptyDataSet(scrollView:UIScrollView) -> NSAttributedString {
        
        let message = Utils.localizedString("There are not videos with that name")
        return NSAttributedString(string: message, attributes: LookAndFeel.style.descriptionEmptyViewAttributes)
    }
    
    func imageForEmptyDataSet(scrollView:UIScrollView) -> UIImage {
        
        return UIImage(named: "saved-videos-empty-state.png")!.imageByApplyingAlpha(0.7)
    }
    
}
