//
//  VideoDAO.swift
//  save5
//
//  Created by José Carlos Sobrino on 31/01/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit
import CoreData

class VideoDAO: BaseDAO {
   
    class var sharedInstance : VideoDAO {
        
        struct Static {
            static let instance : VideoDAO = VideoDAO()
        }
        return Static.instance
    }
    
    private override init(){
        
    }
    
    func findByName(filter: String, var sortDescriptor: NSSortDescriptor?) -> [AnyObject]{
        
        if(sortDescriptor == nil){
            
            sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: "caseInsensitiveCompare:")
        }
        
        let fetchRequest = NSFetchRequest(entityName: Video.entity.name)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [sortDescriptor!]
        
        if(countElements(filter) > 0) {
            
            fetchRequest.predicate = NSPredicate(format: "name contains[cd] %@", filter)
        }
        
        var results = context.executeFetchRequest(fetchRequest, error: nil)!
        return results
    }
    
    
    func createVideo(videoVO: VideoVO) -> Video {
        
        let video = NSEntityDescription.insertNewObjectForEntityForName(Video.entity.name, inManagedObjectContext: context) as Video
        
        video.id = videoVO.id!
        video.name = videoVO.name!
        video.sourcePage = videoVO.sourcePage!
        video.videoFilename = videoVO.videoFilename!
        video.thumbnailFilename = videoVO.thumbnailFilename!
        video.spaceOnDisk = videoVO.spaceOnDisk!
        video.length = videoVO.length!
        
        if videoVO.folder != nil && !(videoVO.folder as NSManagedObject).fault {
            
            video.folder = videoVO.folder
        
        } else {
            
            video.folder = FolderDAO.sharedInstance.getDefaultFolder() as Folder
            
        }
        
        commit()
        
        return video
    }
    
    func createFetchedResultControllerByFolder(folder: Folder, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController{
    
        let sort = NSSortDescriptor(key: "name", ascending: true, selector: "caseInsensitiveCompare:")
        let predicate = NSPredicate(format: "folder.name = %@", folder.name)
        let fetchRequest = NSFetchRequest(entityName: Video.entity.name)
        
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = predicate
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = delegate
        
        var e: NSError?
        if !controller.performFetch(&e) {
            
            println("fetch error: \(e!.localizedDescription)")
            abort();
        }
        
        return controller
    }
    
    func createFetchedResultControllerByName(name: String, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController{
        
        let sort = NSSortDescriptor(key: "name", ascending: true, selector: "caseInsensitiveCompare:")
        let fetchRequest = NSFetchRequest(entityName: Video.entity.name)
        
        fetchRequest.sortDescriptors = [sort]
        
        if(countElements(name) > 0) {
            
            fetchRequest.predicate = NSPredicate(format: "name contains[cd] %@", name)
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = delegate
        
        var e: NSError?
        if !controller.performFetch(&e) {
            
            println("fetch error: \(e!.localizedDescription)")
            abort();
        }
        
        return controller
    }

    
    

}
