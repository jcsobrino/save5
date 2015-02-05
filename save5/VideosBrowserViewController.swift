//
//  VideosBrowserViewController.swift
//  save5
//
//  Created by José Carlos Sobrino on 31/01/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class VideosBrowserViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, DZNEmptyDataSetSource {
    
    let videoDAO = VideoDAO.sharedInstance
    let folderDAO = FolderDAO.sharedInstance
    var folder:Folder?
    
    @IBOutlet weak var tableView: UITableView!
    
    var fetchedResultsController: NSFetchedResultsController {
        // return if already initialized
        if self._fetchedResultsController != nil {
            
            return self._fetchedResultsController!
        }
        
        var delegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedObjectContext = delegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Video", inManagedObjectContext: managedObjectContext)
        let sort = NSSortDescriptor(key: "name", ascending: true)
        let predicate = NSPredicate(format: "folder.name = %@", folder!.name)
        let req = NSFetchRequest()
        
        req.entity = entity
        req.sortDescriptors = [sort]
        req.predicate = predicate
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: req, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        self._fetchedResultsController = aFetchedResultsController
        
        var e: NSError?
        if !self._fetchedResultsController!.performFetch(&e) {
            
            println("fetch error: \(e!.localizedDescription)")
            abort(); //?????
        }
        
        return self._fetchedResultsController!
    }
    
    var _fetchedResultsController: NSFetchedResultsController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.emptyDataSetSource = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        self.title = folder!.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let info = fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return info.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIndentifier = "VideoTableViewCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier, forIndexPath: indexPath) as VideoTableViewCell
        
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell:VideoTableViewCell, indexPath:NSIndexPath){
        
        let video = fetchedResultsController.objectAtIndexPath(indexPath) as Video
        cell.name.text = indexPath.row == 0 ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin aliquet felis nibh, nec bibendum sem varius nec.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin aliquet felis nibh, nec bibendum sem varius nec.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin aliquet felis nibh, nec bibendum sem varius nec" : video.name
        cell.hostname.text = "youtube.com"
        cell.size.text = String(format: "%.2f MBs", video.spaceOnDisk/1024)
        cell.length.text = Utils.formatSeconds(Int(video.length))
        //cell.thumbnail.contentMode = UIViewContentMode.ScaleAspectFit
        //cell.thumbnail.setImage(UIImage(), borderWidth: 5, shadowDepth: 10, controlPointXOffset: 30, controlPointYOffset: 70)
     
        //cell.thumbnail.image = UIImage(named: "loading_thumbnail.png")
        cell.thumbnail.setImage(UIImage(named: "loading_thumbnail.png")!, borderWidth: 3, shadowDepth: 10, controlPointXOffset: 40, controlPointYOffset: 0)
        var thumbnail:UIImage?
        
      //  Async.background {
            
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let pathFile = documentsPath.stringByAppendingPathComponent(video.videoFilename)
            println(pathFile)
            let url = NSURL(fileURLWithPath: pathFile)
            let asset = AVAsset.assetWithURL(url) as AVURLAsset
            let generator = AVAssetImageGenerator(asset: asset)
            let time = CMTimeMake(30, 1)
            var err:NSError?
            let imgRef = generator.copyCGImageAtTime(time, actualTime: nil, error: &err)
            println(err)
            thumbnail = UIImage(CGImage: imgRef)
            
            //thumbnail = UIImage(named: "loading_thumbnail.png")
            
      //  }.main{
                
            cell.thumbnail.setImage(thumbnail!, borderWidth: 5, shadowDepth: 10, controlPointXOffset: 30, controlPointYOffset: 70)
      //  }
        
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject object: AnyObject, atIndexPath indexPath: NSIndexPath,   forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath) {
            
            switch type {
                
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            case .Update:
                let cell = tableView.cellForRowAtIndexPath(indexPath) as VideoTableViewCell
                configureCell(cell, indexPath: indexPath)
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            default:
                return
            }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        tableView.endUpdates()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let indexPath = tableView.indexPathForSelectedRow()
        let video = self.fetchedResultsController.objectAtIndexPath(indexPath!) as Video
        let playerViewController = segue.destinationViewController as PlayerViewController
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let videoFilenameAbsolute = documentsPath.stringByAppendingPathComponent(video.videoFilename)
        
        playerViewController.file = videoFilenameAbsolute
    }
    
    func tableView(tableView: UITableView!, editActionsForRowAtIndexPath indexPath: NSIndexPath!) -> [AnyObject] {
        
        var deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { (action, indexPath) -> Void in
            
            tableView.editing = false
            let video = self.fetchedResultsController.objectAtIndexPath(indexPath!) as Video
            
            var alert = UIAlertController(title: Utils.localizedString("Confirm action"), message: Utils.localizedString("Do you really want to delete this item?"), preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: Utils.localizedString("No"), style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: Utils.localizedString("Yes"), style: .Destructive) { (action) in
                
                let fileManager = NSFileManager.defaultManager()
                let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
                let pathFileAbsolute = documentsPath.stringByAppendingPathComponent(video.videoFilename)
               // let pathFileThumbnail = documentsPath.stringByAppendingPathComponent(storedVideo.valueForKey("thumbnailFilename")! as String)
                //fileManager.removeItemAtPath(pathFileThumbnail, error: nil)
                fileManager.removeItemAtPath(pathFileAbsolute, error: nil)
                self.videoDAO.deleteObject(video)
            })
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        var moveToFolderAction = UITableViewRowAction(style: .Default, title: "Move") { (action, indexPath) -> Void in
            
            tableView.editing = false
            let video = self.fetchedResultsController.objectAtIndexPath(indexPath!) as Video
            
            let actionSheet =  UIAlertController(title: Utils.localizedString("Select folder to move"), message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let folders = self.folderDAO.findAll() as [Folder]
            
            for folder in folders  {
                
                if(folder != self.folder){
                    
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
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
    }
    
    func titleForEmptyDataSet(scrollView:UIScrollView) -> NSAttributedString {
        
        let message = Utils.localizedString("No saved videos")
        return NSAttributedString(string: message, attributes: LookAndFeel.style.titleEmptyViewAttributes)
    }
    
    func descriptionForEmptyDataSet(scrollView:UIScrollView) -> NSAttributedString {
        
        let message = Utils.localizedString("There are not videos in this view")
        return NSAttributedString(string: message, attributes: LookAndFeel.style.descriptionEmptyViewAttributes)
    }
    
    func imageForEmptyDataSet(scrollView:UIScrollView) -> UIImage {
        
        return UIImage(named: "saved-videos-empty-state.png")!.imageByApplyingAlpha(0.7)
    }

    
    
    
}
