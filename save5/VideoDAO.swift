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
   
    class var sharedInstance: VideoDAO {
        struct Static {
            static var instance: VideoDAO?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = VideoDAO()
        }
        
        return Static.instance!
    }
    
    func findByTitleOrAuthor(filter: String, var sortDescriptor: NSSortDescriptor?) -> [AnyObject]{
        
        if(sortDescriptor == nil){
            
            sortDescriptor = NSSortDescriptor(key: "title", ascending: true, selector: "caseInsensitiveCompare:")
        }
        
        let fetchRequest = NSFetchRequest(entityName: "Video")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [sortDescriptor!]
        
        if(countElements(filter) > 0) {
            
            let predicate = NSPredicate(format: "author contains[cd] %@ OR title contains[cd] %@", filter, filter)
            fetchRequest.predicate = predicate
        }
        
        var results = context.executeFetchRequest(fetchRequest, error: nil)!
        return results
    }
    
    
    func saveVideo(videoVO: VideoVO) -> NSError?{
        
        let video = NSEntityDescription.insertNewObjectForEntityForName("Video", inManagedObjectContext: context) as Video
        var error:NSError?
        
        video.id = videoVO.id!
        video.name = videoVO.name!
        //video.thumbnailFilename = filename
        video.spaceOnDisk = videoVO.spaceOnDisk!
        video.length = videoVO.length!
        video.folder = FolderDAO.sharedInstance.getDefaultFolder() as Folder
        
        context.save(&error)
        return error
    }

}
