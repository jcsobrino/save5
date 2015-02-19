//
//  VideosCollectionBrowserViewController.swift
//  save5
//
//  Created by José Carlos Sobrino on 05/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit
import CoreData
import iAd

class FoldersCollectionBrowserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate, ADBannerViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var iADBanner: ADBannerView!
    
    let cellIndentifier = "FolderCollectionViewCell"
    var newFolderButton: UIBarButtonItem!
    var searchVideosButton: UIBarButtonItem!
    
    
    lazy var searchController:UISearchController = {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let resultsTableController = storyBoard.instantiateViewControllerWithIdentifier("searchVideosTableViewController") as SearchVideosTableViewController
        let searchController = UISearchController(searchResultsController: resultsTableController)
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.barStyle = UIBarStyle.BlackTranslucent
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
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
        
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(image: LookAndFeel.icons.addFolderIcon, style: UIBarButtonItemStyle.Plain, target: self, action: "createNewFolderButtonClicked"), animated: true)
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(image: LookAndFeel.icons.searchVideosIcon, style: UIBarButtonItemStyle.Plain, target: self, action: "searchVideosButtonClicked"), animated: true)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.delaysContentTouches = false
        let layout = collectionView.collectionViewLayout as UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.sectionInset = UIEdgeInsetsZero
        
        let deleteFolderMenuItem = UIMenuItem(title: "Delete", action: "deleteFolder")
        let renameFolderMenuItem = UIMenuItem(title: "Rename", action: "renameFolder")
        UIMenuController.sharedMenuController().menuItems = NSArray(array:[renameFolderMenuItem, deleteFolderMenuItem])
        
        iADBanner.delegate = self
        iADBanner.alpha = 0
        
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
        
            var thumbnailFilename = "folder-empty.png"
            
            if (folder.videos.count > 0){
            
                let firstVideoOfFolder = folder.videos.firstObject as Video
                thumbnailFilename = Utils.utils.documentsPath.stringByAppendingPathComponent(firstVideoOfFolder.thumbnailFilename)
            }
            
            cell.name.text = folder.name
            cell.spaceOnDisk.attributedText = Utils.createMutableAttributedString(LookAndFeel.icons.spaceOnDiskIcon, text: String(format: "%.2f MB", folder.spaceOnDisk/1024))
            cell.numVideos.attributedText = Utils.createMutableAttributedString(LookAndFeel.icons.numberVideosIcon, text: String(format:"%d", folder.videos.count))
            cell.thumbnail.image = UIImage(named: thumbnailFilename)
            
        }
    }

    func controller(controller: NSFetchedResultsController, didChangeObject object: AnyObject, atIndexPath indexPath: NSIndexPath,   forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath) {
            
            switch type {
            
            case .Insert:
                collectionView.insertItemsAtIndexPaths([newIndexPath])
            case .Update:
                let cell = collectionView.cellForItemAtIndexPath(indexPath) as FolderCollectionViewCell
                configureCell(cell, indexPath: indexPath)
                collectionView.reloadItemsAtIndexPaths([indexPath])
            case .Delete:
                collectionView.deleteItemsAtIndexPaths([indexPath])
            default:
                return
            }
    }
    
    func createNewFolderButtonClicked() {
        
        let alertController = UIAlertController(title: Utils.localizedString("Create new folder"), message: Utils.localizedString("Write the new folder's name"), preferredStyle: .Alert)
        
        let allFolderNames = (FolderDAO.sharedInstance.findAll() as [Folder]).map{ $0.name }
        
        alertController.addAction(UIAlertAction(title: Utils.localizedString("Cancel"), style: .Cancel, handler: nil))
        let createAction =  UIAlertAction(title: Utils.localizedString("Create"), style: .Default) { (action) in
            
            let nameTextField = alertController.textFields![0] as UITextField
            
            FolderDAO.sharedInstance.saveFolder(nameTextField.text)
        }
        
        createAction.enabled = false
        
        alertController.addAction(createAction)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Folder's name"
            textField.enablesReturnKeyAutomatically = false
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                
                createAction.enabled = textField.text != "" && !contains(allFolderNames, textField.text)
                
            }
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let indexPath = collectionView.indexPathsForSelectedItems()[0] as NSIndexPath
        let folder = self.fetchedResultsController.objectAtIndexPath(indexPath) as Folder
        let videosBrowserViewController = segue.destinationViewController as VideosBrowserViewController
        
        videosBrowserViewController.folder = folder
    }

    func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        let folder = self.fetchedResultsController.objectAtIndexPath(indexPath) as Folder
        
        if (folder.defaultFolder){
            
            var alertController = UIAlertController(title: Utils.localizedString("Modifier folder"), message: Utils.localizedString("This folder cannot be deleted nor modified"), preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(title: Utils.localizedString("OK"), style: .Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        return !folder.defaultFolder
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
            let allFolderNames = (FolderDAO.sharedInstance.findAll() as [Folder]).map{ $0.name }
        
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
                    
                    createAction.enabled = textField.text != "" && !contains(allFolderNames, textField.text)
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
        
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(image: LookAndFeel.icons.addFolderIcon, style: UIBarButtonItemStyle.Plain, target: self, action: "createNewFolderButtonClicked"), animated: true)
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(image: LookAndFeel.icons.searchVideosIcon, style: UIBarButtonItemStyle.Plain, target: self, action: "searchVideosButtonClicked"), animated: true)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        
        collectionView.collectionViewLayout.invalidateLayout()
        calculateItemsSize()
    }
    
    func calculateItemsSize(){
        
        var deviceHeight = UIScreen.mainScreen().nativeBounds.height
        var numColumns = 2
        
        if(UIApplication.sharedApplication().statusBarOrientation.isLandscape){
            
            switch(deviceHeight){
                
            case 960: numColumns = 3
            case 1136: numColumns = 4
            case 1334: numColumns = 5
            case 2001: numColumns = 6
            case 2208: numColumns = 6
            default: numColumns = 3
            }
        }
        println(numColumns)
        let layout = collectionView.collectionViewLayout as UICollectionViewFlowLayout
        let inset = layout.sectionInset
        let marginCells = layout.minimumInteritemSpacing * CGFloat(numColumns - 1)
        let marginInsets = inset.left + inset.right
        let widthCell = (collectionView.superview!.frame.width - marginInsets - marginCells) / CGFloat(numColumns)
        
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
    
    func bannerViewDidLoadAd(banner: ADBannerView!){
        
        UIView.animateWithDuration(0.5) {
            
            let iADBannerHeight = self.iADBanner.frame.height
            self.iADBanner.alpha = 1
            self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, iADBannerHeight, 0);
        }
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!){
        
        UIView.animateWithDuration(0.5) {
            
            self.iADBanner.alpha = 0
            self.collectionView.contentInset = UIEdgeInsetsZero
        }
    }
}
