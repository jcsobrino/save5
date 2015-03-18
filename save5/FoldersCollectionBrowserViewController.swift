//
//  VideosCollectionBrowserViewController.swift
//  save5
//
//  Created by José Carlos Sobrino on 05/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit
import CoreData


class FoldersCollectionBrowserViewController: UICollectionViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate {
    
    let cellIndentifier = "FolderCollectionViewCell"
    var newFolderButton: UIBarButtonItem!
    var searchVideosButton: UIBarButtonItem!
    let textFieldNoReturnAux = NoReturnKeyTextfield()
    var fetchedResultsController: NSFetchedResultsController!
    
    lazy var searchController:UISearchController = {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let resultsTableController = storyBoard.instantiateViewControllerWithIdentifier("SearchVideosTableViewController") as SearchVideosTableViewController
        let searchController = UISearchController(searchResultsController: resultsTableController)
        
        searchController.searchResultsUpdater = resultsTableController
        searchController.searchBar.sizeToFit()
        searchController.searchBar.initIcons()
        searchController.searchBar.placeholder = Utils.localizedString("Find Videos")
        searchController.searchBar.barStyle = UIBarStyle.BlackTranslucent
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
    
        return searchController
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        fetchedResultsController = FolderDAO.sharedInstance.createFetchedResultControllerAllFolders(self)
        
        newFolderButton = UIBarButtonItem(image: LookAndFeel.icons.addFolderIcon, style: .Plain, target: self, action: "createNewFolderButtonClicked")
        searchVideosButton = UIBarButtonItem(image: LookAndFeel.icons.searchVideosIcon, style: .Plain, target: self, action: "searchVideosButtonClicked")
        
        self.navigationItem.setLeftBarButtonItem(newFolderButton, animated: true)
        self.navigationItem.setRightBarButtonItem(searchVideosButton, animated: true)
        searchController.searchBar.getTextField()!.textColor = LookAndFeel.style.searchBarTextColor
    
        collectionView!.delaysContentTouches = false
        let layout = collectionView!.collectionViewLayout as UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.sectionInset = UIEdgeInsetsZero
        
        let deleteFolderMenuItem = UIMenuItem(title: Utils.localizedString("Delete"), action: FolderCollectionViewCell.menuActions.delete)
        let renameFolderMenuItem = UIMenuItem(title: Utils.localizedString("Rename"), action: FolderCollectionViewCell.menuActions.rename)
        UIMenuController.sharedMenuController().menuItems = NSArray(array:[renameFolderMenuItem, deleteFolderMenuItem])
        
        calculateItemsSize()
        self.title = Utils.localizedString("Folders")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let info = fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return info.numberOfObjects
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIndentifier, forIndexPath: indexPath) as FolderCollectionViewCell
        
        configureCell(cell, indexPath: indexPath)
    
        return cell
    }
    
    func configureCell(cell:FolderCollectionViewCell, indexPath:NSIndexPath){
        
        let folder = fetchedResultsController.objectAtIndexPath(indexPath) as Folder
       
        Async.main {
        
          if (folder.videos.count > 0){
            
                let firstVideoOfFolder = folder.videos.firstObject as Video
                let thumbnailFilename = Utils.utils.documentsPath.stringByAppendingPathComponent(firstVideoOfFolder.thumbnailFilename)
                cell.thumbnail.contentMode = UIViewContentMode.ScaleToFill
                cell.thumbnail.image = UIImage(named: thumbnailFilename)
                
            } else {
            
                cell.thumbnail.contentMode = UIViewContentMode.Center
                cell.thumbnail.image = LookAndFeel.icons.emptyFolderIcon
            }
            
            cell.name.text = folder.name
            cell.spaceOnDisk.attributedText = Utils.createMutableAttributedString(LookAndFeel.icons.spaceOnDiskIcon, text: Utils.prettyLengthFile(folder.spaceOnDisk))
            
            cell.numVideos.attributedText = Utils.createMutableAttributedString(LookAndFeel.icons.numberVideosIcon, text: String(format:"%d", folder.videos.count))
           
        }
    }

    func controller(controller: NSFetchedResultsController, didChangeObject object: AnyObject, atIndexPath indexPath: NSIndexPath,   forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath) {
           
            log.debug("Changes in folder: \(type.rawValue)")
            
            switch type {
            
            case .Insert:
                collectionView!.insertItemsAtIndexPaths([newIndexPath])
            case .Move:
                collectionView!.moveItemAtIndexPath(indexPath, toIndexPath: newIndexPath)
                collectionView!.reloadItemsAtIndexPaths([indexPath, newIndexPath])
            case .Update:
                if let cell = collectionView!.cellForItemAtIndexPath(indexPath) as? FolderCollectionViewCell{
                
                    configureCell(cell, indexPath: indexPath)
                    collectionView!.reloadItemsAtIndexPaths([indexPath])
                }
            case .Delete:
                collectionView!.deleteItemsAtIndexPaths([indexPath])
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
            
            FolderDAO.sharedInstance.createFolder(nameTextField.text)
        }
        
        createAction.enabled = false
        
        alertController.addAction(createAction)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            
            textField.placeholder = Utils.localizedString("Folder's name")
            textField.enablesReturnKeyAutomatically = false
            textField.delegate = self.textFieldNoReturnAux
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                
                createAction.enabled = textField.text != "" && !contains(allFolderNames, textField.text)
                
            }
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let indexPath = collectionView!.indexPathsForSelectedItems()[0] as NSIndexPath
        let folder = self.fetchedResultsController.objectAtIndexPath(indexPath) as Folder
        let videosBrowserViewController = segue.destinationViewController as VideosBrowserViewController
        
        videosBrowserViewController.folder = folder
    }

    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        let folder = self.fetchedResultsController.objectAtIndexPath(indexPath) as Folder
        
        if (folder.defaultFolder){
            
            var alertController = UIAlertController(title: Utils.localizedString("Modify folder"), message: Utils.localizedString("This folder cannot be deleted nor modified"), preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(title: Utils.localizedString("OK"), style: .Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        return !folder.defaultFolder
    }
    
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject!) -> Bool {
        
        return true
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject!) {
      
        if(action == FolderCollectionViewCell.menuActions.rename){
            
            let folder = self.fetchedResultsController.objectAtIndexPath(indexPath) as Folder
            let allFolderNames = (FolderDAO.sharedInstance.findAll() as [Folder]).map{ $0.name }
        
            var alertController = UIAlertController(title: Utils.localizedString("Rename folder"), message: Utils.localizedString("Write the folder's name"), preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(title: Utils.localizedString("Cancel"), style: .Cancel, handler: nil))
            let createAction =  UIAlertAction(title: Utils.localizedString("Accept"), style: .Default) { (action) in
                
                
                let nameTextField = alertController.textFields![0] as UITextField
                
                folder.name = nameTextField.text
                
                FolderDAO.sharedInstance.updateObject(folder)
            }
            
            createAction.enabled = false
            
            alertController.addAction(createAction)
            
            alertController.addTextFieldWithConfigurationHandler { (textField) in
                
                textField.placeholder = Utils.localizedString("Folder's name")
                textField.text = folder.name
                textField.delegate = self.textFieldNoReturnAux
                
                NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                    
                    createAction.enabled = textField.text != "" && !contains(allFolderNames, textField.text)
                }
            }
            
            self.presentViewController(alertController, animated: true, completion: nil)

        } else if(action == FolderCollectionViewCell.menuActions.delete) {
            
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

        self.navigationItem.setLeftBarButtonItem(nil, animated: true)
        self.navigationItem.setRightBarButtonItem(nil, animated: true)
        self.navigationItem.titleView = searchController.searchBar
        searchController.searchBar.becomeFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
   
        self.navigationItem.titleView = nil
        self.navigationItem.setLeftBarButtonItem(newFolderButton, animated: true)
        self.navigationItem.setRightBarButtonItem(searchVideosButton, animated: true)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        
        collectionView!.collectionViewLayout.invalidateLayout()
        calculateItemsSize()
    }
    
    private func calculateItemsSize(){
        
        let isPortraitOrientation = UIApplication.sharedApplication().statusBarOrientation.isPortrait
        
        var numColumns: Int!
        
        if(isPortraitOrientation){
            
            numColumns = deviceSize == .iPhone55inch ? 3 : 2
            
        } else {
            
            numColumns = deviceSize == .iPhone35inch ? 3 : contains([.iPhone4inch, .iPhone47inch], deviceSize) ? 4 : 5
        }
        
        log.debug("Portrait Orientation: \(isPortraitOrientation) Device Size: \(deviceSize.rawValue) NumColumns \(numColumns)")
        
        let layout = collectionView!.collectionViewLayout as UICollectionViewFlowLayout
        let inset = layout.sectionInset
        let marginCells = layout.minimumInteritemSpacing * CGFloat(numColumns - 1)
        let marginInsets = inset.left + inset.right
        let widthCell = (collectionView!.superview!.frame.width - marginInsets - marginCells) / CGFloat(numColumns)
        
        layout.itemSize = CGSizeMake(widthCell, widthCell * 0.85)
    }
    
    override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        
        var cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.contentView.backgroundColor = LookAndFeel.style.cellHighlightColor
    }
    
    override func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
     
        var cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.contentView.backgroundColor = LookAndFeel.style.cellBackgroundColor
    }
}
