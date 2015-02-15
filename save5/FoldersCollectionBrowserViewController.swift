//
//  VideosCollectionBrowserViewController.swift
//  save5
//
//  Created by José Carlos Sobrino on 05/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit
import CoreData

class FoldersCollectionBrowserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    @IBOutlet weak var tableView: UICollectionView!
    
    let cellIndentifier = "FolderCollectionViewCell"
    var newFolderButton: UIBarButtonItem!
    var searchVideosButton: UIBarButtonItem!
    
    lazy var searchController:UISearchController = {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let resultsTableController = storyBoard.instantiateViewControllerWithIdentifier("searchVideosTableViewController") as SearchVideosTableViewController
        let searchController = UISearchController(searchResultsController: resultsTableController)
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.definesPresentationContext = true
        
        return searchController
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedObjectContext = delegate.managedObjectContext!
        let entity = NSEntityDescription.entityForName("Folder", inManagedObjectContext: managedObjectContext)
        let sort = NSSortDescriptor(key: "name", ascending: true)
        let req = NSFetchRequest()
        
        req.entity = entity
        req.sortDescriptors = [sort]
        
        let controller = NSFetchedResultsController(fetchRequest: req, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        var e: NSError?
        if !controller.performFetch(&e) {
            
            println("fetch error: \(e!.localizedDescription)")
            abort(); //?????
        }
        
        return controller
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(image: LookAndFeel().addFolderIcon, style: UIBarButtonItemStyle.Plain, target: self, action: "createNewFolderButtonClicked"), animated: true)
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(image: LookAndFeel().searchVideosIcon, style: UIBarButtonItemStyle.Plain, target: self, action: "searchVideosButtonClicked"), animated: true)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.delaysContentTouches = false
        let layout = tableView.collectionViewLayout as UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.sectionInset = UIEdgeInsetsZero
        
        let deleteFolderMenuItem = UIMenuItem(title: "Delete", action: "deleteFolder")
        let renameFolderMenuItem = UIMenuItem(title: "Rename", action: "renameFolder")
        UIMenuController.sharedMenuController().menuItems = NSArray(array:[renameFolderMenuItem, deleteFolderMenuItem])
        
        calculateItemsSize()
        self.title = "Folders"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let info = fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return info.numberOfObjects
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIndentifier, forIndexPath: indexPath) as FolderCollectionViewCell
        
        configureCell(cell, indexPath: indexPath)
    
        return cell
    }
    
    func configureCell(cell:FolderCollectionViewCell, indexPath:NSIndexPath){
        
        let folder = fetchedResultsController.objectAtIndexPath(indexPath) as Folder
       
        Async.main {
        
            var thumbnailFilename = "350D_IMG_3157_20071030w.jpg"
            
            if (folder.videos.count > 0){
            
                let firstVideoOfFolder = folder.videos.firstObject as Video
                thumbnailFilename = Utils.utils.documentsPath.stringByAppendingPathComponent(firstVideoOfFolder.thumbnailFilename)
            }
            
            cell.name.text = folder.name
             cell.spaceOnDisk.attributedText = Utils.createMutableAttributedString(LookAndFeel().spaceOnDiskIcon, text: String(format: "%.2f MB", folder.spaceOnDisk/1024))
            cell.numVideos.attributedText = Utils.createMutableAttributedString(LookAndFeel().numberVideosIcon, text: String(format:"%d", folder.videos.count))
            cell.thumbnail.image = UIImage(named: thumbnailFilename)
        }
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
        
        let indexPath = tableView.indexPathsForSelectedItems()[0] as NSIndexPath
        let folder = self.fetchedResultsController.objectAtIndexPath(indexPath) as Folder
        let videosBrowserViewController = segue.destinationViewController as VideosBrowserViewController
        
        videosBrowserViewController.folder = folder
    }

    func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        let folder = self.fetchedResultsController.objectAtIndexPath(indexPath) as Folder
        
        return folder.name != "Downloads" // Revisar!!!!!!!!!!!
    }
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        var data = VideoDAO.sharedInstance.findByName(searchController.searchBar.text, sortDescriptor: nil)
        var innerController = searchController.searchResultsController as SearchVideosTableViewController
        innerController.data = data
        
        innerController.tableView?.reloadData()
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
                    
                    (video as Video).folder = FolderDAO.sharedInstance.getDefaultFolder() as Folder
                }
                
                FolderDAO.sharedInstance.deleteObject(folder)
            })
            
            alert.addAction(UIAlertAction(title: Utils.localizedString("Folder + videos"), style: .Destructive) { (action) in
                
                for video in folder.videos.array {
                    
                    FolderDAO.sharedInstance.deleteObject(video as NSManagedObject)
                }
                
                FolderDAO.sharedInstance.deleteObject(folder)
            })
            
            self.presentViewController(alert, animated: true, completion: nil)
     }
    }
   
    func searchVideosButtonClicked(){
    
        self.navigationItem.titleView = searchController.searchBar
        searchController.searchBar.getTextField()!.textColor = LookAndFeel.style.searchBarTextColor
        searchController.searchBar.becomeFirstResponder()
        self.navigationItem.setLeftBarButtonItem(nil, animated: true)
        self.navigationItem.setRightBarButtonItem(nil, animated: true)
        searchController.active = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
   
        self.searchController.active = false
        self.navigationItem.titleView = nil
        
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(image: LookAndFeel().addFolderIcon, style: UIBarButtonItemStyle.Plain, target: self, action: "createNewFolderButtonClicked"), animated: true)
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(image: LookAndFeel().searchVideosIcon, style: UIBarButtonItemStyle.Plain, target: self, action: "searchVideosButtonClicked"), animated: true)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        
        tableView.collectionViewLayout.invalidateLayout()
        calculateItemsSize()
    }
    
    func calculateItemsSize(){
        
        let numColumns = UIApplication.sharedApplication().statusBarOrientation.isPortrait ? 2 : 3 // Depende del tamaño de la pantalla
        let layout = tableView.collectionViewLayout as UICollectionViewFlowLayout
        let inset = layout.sectionInset
        let marginCells = layout.minimumInteritemSpacing * CGFloat(numColumns - 1)
        let marginInsets = inset.left + inset.right
        let widthCell = (tableView.superview!.frame.width - marginInsets - marginCells) / CGFloat(numColumns)
        
        layout.itemSize = CGSizeMake(widthCell, widthCell * 0.85)
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        
        var cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.contentView.backgroundColor = LookAndFeel.colorWithHexString("e5e5e5")
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
     
        var cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.contentView.backgroundColor = UIColor.whiteColor()
    }
}
