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
        
        let fetchRequest = NSFetchRequest(entityName: "Video")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [sortDescriptor!]
        
        if(countElements(filter) > 0) {
            
            let predicate = NSPredicate(format: "name contains[cd] %@", filter, filter)
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
        
        context.save(&error)
        return error
    }

}
