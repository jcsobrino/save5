//
//  FoldersBrowserViewController.swift
//  save5
//
//  Created by José Carlos Sobrino on 31/01/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit
import CoreData

class FoldersBrowserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, DZNEmptyDataSetSource {
    
    
    let folderDAO = FolderDAO.sharedInstance
    
    @IBOutlet weak var newFolderButton: UIBarButtonItem!
    @IBOutlet weak var searchVideosButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var fetchedResultsController: NSFetchedResultsController {
        // return if already initialized
        if self._fetchedResultsController != nil {
            
            return self._fetchedResultsController!
        }
      
        var delegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedObjectContext = delegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Folder", inManagedObjectContext: managedObjectContext)
        let sort = NSSortDescriptor(key: "name", ascending: true)
        let req = NSFetchRequest()
        req.entity = entity
        req.sortDescriptors = [sort]
        
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
        
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.emptyDataSetSource = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()

        self.title = "Folders"
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
        
        let cellIndentifier = "FolderTableViewCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier) as FolderTableViewCell
        
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell:FolderTableViewCell, indexPath:NSIndexPath){
        
        let folder = fetchedResultsController.objectAtIndexPath(indexPath) as Folder
        cell.info.text = String(format:"%@ - %d - %.2f MBs", folder.name, folder.videos.count, folder.spaceOnDisk/1024)
        
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
                let cell = tableView.cellForRowAtIndexPath(indexPath) as FolderTableViewCell
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
    
    
    func tableView(tableView: UITableView!, editActionsForRowAtIndexPath indexPath: NSIndexPath!) -> [AnyObject] {
        
        var cancelAction = UITableViewRowAction(style: .Default, title: "Delete") { (action, indexPath) -> Void in
            
            tableView.editing = false
            let folder = self.fetchedResultsController.objectAtIndexPath(indexPath) as Folder
            
            var alert = UIAlertController(title: Utils.localizedString("Confirm action"), message: Utils.localizedString("Do you really want to delete this folder?"), preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: Utils.localizedString("No"), style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: Utils.localizedString("Only folder"), style: .Destructive) { (action) in
                
               for video in folder.videos.array {
                    
                    (video as Video).folder = self.folderDAO.getDefaultFolder() as Folder
                }
                
                self.folderDAO.deleteObject(folder)
            })
            
            alert.addAction(UIAlertAction(title: Utils.localizedString("Folder + videos"), style: .Destructive) { (action) in
                
                for video in folder.videos.array {

                    self.folderDAO.deleteObject(video as NSManagedObject)
                }
                
                self.folderDAO.deleteObject(folder)
            })
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        var renameAction = UITableViewRowAction(style: .Default, title: "Rename") { (action, indexPath) -> Void in
            
            tableView.editing = false
            let folder = self.fetchedResultsController.objectAtIndexPath(indexPath) as Folder
            
            var alertController = UIAlertController(title: Utils.localizedString("Rename folder"), message: Utils.localizedString("Write the folder's name"), preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(title: Utils.localizedString("Cancel"), style: .Cancel, handler: nil))
            let createAction =  UIAlertAction(title: Utils.localizedString("Accept"), style: .Default) { (action) in
                
                
                let nameTextField = alertController.textFields![0] as UITextField
                
                folder.name = nameTextField.text
            }
            
            createAction.enabled = false
            
            alertController.addAction(createAction)
            
            alertController.addTextFieldWithConfigurationHandler { (textField) in
               
                textField.placeholder = "Folder's name"
                textField.text = folder.name
                
                NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                    createAction.enabled = textField.text != ""
                }
            }
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        renameAction.backgroundColor = LookAndFeel.style.clearBlueApple
        
        return [cancelAction, renameAction]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        let folder = self.fetchedResultsController.objectAtIndexPath(indexPath) as Folder

        return folder.name != "Downloads"
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
    }
    
    @IBAction func createNewFolder() {
        
        var alertController = UIAlertController(title: Utils.localizedString("Create new folder"), message: Utils.localizedString("Write the new folder's name"), preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: Utils.localizedString("Cancel"), style: .Cancel, handler: nil))
        let createAction =  UIAlertAction(title: Utils.localizedString("Create"), style: .Default) { (action) in
            
            let nameTextField = alertController.textFields![0] as UITextField
            
            FolderDAO.sharedInstance.saveFolder(nameTextField.text)
        }
        
        createAction.enabled = false
        
        alertController.addAction(createAction)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Folder's name"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                createAction.enabled = textField.text != ""
            }
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let indexPath = tableView.indexPathForSelectedRow()
        let folder = self.fetchedResultsController.objectAtIndexPath(indexPath!) as Folder
        let videosBrowserViewController = segue.destinationViewController as VideosBrowserViewController
        
        videosBrowserViewController.folder = folder
        
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
