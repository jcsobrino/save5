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
            
            let predicate = NSPredicate(format: "name contains[cd] %@", filter, filter)
            fetchRequest.predicate = predicate
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
        
        if let folder = videoVO.folder {
            
            video.folder = folder
        
        } else {
            
            video.folder = FolderDAO.sharedInstance.getDefaultFolder() as Folder
            
        }
        
        commit()
        
        return video
    }
    
    func createFetchedResultControllerByFolder(folder: Folder, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController{
    
        let entity = NSEntityDescription.entityForName(Video.entity.name, inManagedObjectContext: context)
        let sort = NSSortDescriptor(key: "name", ascending: true, selector: "caseInsensitiveCompare:")
        let predicate = NSPredicate(format: "folder = %@", folder)
        let req = NSFetchRequest()
        
        req.entity = entity
        req.sortDescriptors = [sort]
        req.predicate = predicate
        
        let controller = NSFetchedResultsController(fetchRequest: req, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = delegate
        
        var e: NSError?
        if !controller.performFetch(&e) {
            
            println("fetch error: \(e!.localizedDescription)")
            abort();
        }
        
        return controller
    }
    
    
    

}
