//
//  VideosCollectionBrowserViewController.swift
//  save5
//
//  Created by José Carlos Sobrino on 05/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit
import CoreData

class FoldersCollectionBrowserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, DZNEmptyDataSetSource, UISearchControllerDelegate {
    
    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    let folderDAO = FolderDAO.sharedInstance
    
    @IBOutlet weak var searchBar: UISearchBar!
    var newFolderButton: UIBarButtonItem!
    var searchVideosButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UICollectionView!
    
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
        
    
    
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "createNewFolderButtonClicked"), animated: true)
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "searchVideosButtonClicked"), animated: true)
    
  
        return self._fetchedResultsController!
    
    }
    
    var _fetchedResultsController: NSFetchedResultsController?
    
    
    var searchController:UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.emptyDataSetSource = self
        tableView.dataSource = self
        tableView.delegate = self
    
        self.title = "Folders"
        calculateItemsSize()
        
        var deleteFolderMenuItem = UIMenuItem(title: "Delete", action: "deleteFolder")
        var renameFolderMenuItem = UIMenuItem(title: "Rename", action: "renameFolder")
        UIMenuController.sharedMenuController().menuItems = NSArray(array:[renameFolderMenuItem, deleteFolderMenuItem])
        
    
    
    
        self.searchController = ({
            
            let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            var resultsTableController = SearchVideosTableViewController()
            
            resultsTableController = storyBoard.instantiateViewControllerWithIdentifier("searchVideosTableViewController") as SearchVideosTableViewController
            
            //resultsTableController = ResultsTableController()
            
            // We want to be the delegate for our filtered table so didSelectRowAtIndexPath(_:) is called for both tables.
            //resultsTableController.tableView.delegate = self
            
            var searchController = UISearchController(searchResultsController: resultsTableController)
            searchController.searchResultsUpdater = self
            searchController.searchBar.sizeToFit()
            //self.navigationItem.titleView = searchController.searchBar
            
            searchController.delegate = self
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.dimsBackgroundDuringPresentation = false // default is YES
            searchController.searchBar.delegate = self    // so we can monitor text changes + others
            
            // Search is now just presenting a view controller. As such, normal view controller
            // presentation semantics apply. Namely that presentation will walk up the view controller
            // hierarchy until it finds the root view controller or one that defines a presentation context.
            searchController.definesPresentationContext = true
            
            
            return searchController
        })()

    
    
    
    
    
    
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        var data = VideoDAO.sharedInstance.findByName(searchController.searchBar.text, sortDescriptor: nil)
        var ui = searchController.searchResultsController as SearchVideosTableViewController
        ui.data = data
        
       ui.tableView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        
        tableView.collectionViewLayout.invalidateLayout()
        calculateItemsSize()
    }
    
    
    func calculateItemsSize(){
        
        let deviceOrientation = UIApplication.sharedApplication().statusBarOrientation
        
        let layout = tableView.collectionViewLayout as UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
       
        if(deviceOrientation.isPortrait){
            
            layout.itemSize = CGSizeMake(tableView.superview!.frame.width/2-0.5, tableView.frame.height/3-0.5)
        
        } else {
        
            layout.itemSize = CGSizeMake(tableView.superview!.frame.width/3-1, tableView.frame.height/2-0.5)
        }
        
        
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let info = fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return info.numberOfObjects
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellIndentifier = "FolderCollectionViewCell"
        var cell = tableView.dequeueReusableCellWithReuseIdentifier(cellIndentifier, forIndexPath: indexPath) as FolderCollectionViewCell
        
        configureCell(cell, indexPath: indexPath)
    
        return cell
    }
    
    func configureCell(cell:FolderCollectionViewCell, indexPath:NSIndexPath){
        
        let folder = fetchedResultsController.objectAtIndexPath(indexPath) as Folder
       
        Async.main {
        
            var thumbnailFilename = ""
            
            if (folder.videos.count == 0) {
                
                thumbnailFilename = "350D_IMG_3157_20071030w.jpg"
                
            } else {
            
                var video = folder.videos.firstObject as Video
                
                 thumbnailFilename = self.documentsPath.stringByAppendingPathComponent((folder.videos.array[0] as Video).thumbnailFilename)
            }
            
            cell.name.text = folder.name
            cell.info.text = String(format:"%d videos. %.2f MBs", folder.videos.count, folder.spaceOnDisk/1024)
            cell.thumbnail.image = UIImage(named: thumbnailFilename)
        }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
       
        //tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject object: AnyObject, atIndexPath indexPath: NSIndexPath,   forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath) {
            
            switch type {
            
            case .Insert:
                tableView.insertItemsAtIndexPaths([newIndexPath])
            case .Update:
                let cell = tableView.cellForItemAtIndexPath(indexPath) as FolderCollectionViewCell
                configureCell(cell, indexPath: indexPath)
                tableView.reloadItemsAtIndexPaths([indexPath])
            case .Delete:
                tableView.deleteItemsAtIndexPaths([indexPath])
            default:
                return
            }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
       
        //tableView.endUpdates()
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
    
    func createNewFolderButtonClicked() {
        
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
        
        let indexPath = tableView.indexPathsForSelectedItems()[0]
        let folder = self.fetchedResultsController.objectAtIndexPath(indexPath as NSIndexPath) as Folder
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

    func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        let folder = self.fetchedResultsController.objectAtIndexPath(indexPath) as Folder
        
        return folder.name != "Downloads"
    }
    
    func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject!) -> Bool {
        
        return true
    }

    func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject!) {
      
        if(action.description == "renameFolder"){
            
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

        } else if(action.description == "deleteFolder") {
            
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
        
        
        
    }
   
    func searchVideosButtonClicked(){
    
        self.navigationItem.titleView = searchController!.searchBar
        searchController!.searchBar.becomeFirstResponder()
        self.navigationItem.setLeftBarButtonItem(nil, animated: true)
        self.navigationItem.setRightBarButtonItem(nil, animated: true)
        searchController!.active = true
   
    
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
   
        Async.main{
       
            self.searchController!.active = false
            self.navigationItem.titleView = nil
            self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "createNewFolderButtonClicked"), animated: true)
            self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "searchVideosButtonClicked"), animated: true)
        }
    

    }

}
