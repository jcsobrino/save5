//
//  FolderDAO.swift
//  save5
//
//  Created by José Carlos Sobrino on 31/01/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit
import CoreData

class FolderDAO: BaseDAO {
   
    class var sharedInstance: FolderDAO {
        struct Static {
            static var instance: FolderDAO?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = FolderDAO()
        }
        
        return Static.instance!
    }
    
    func saveFolder(name:String) -> NSError?{
        
        let folderMO = NSEntityDescription.insertNewObjectForEntityForName("Folder", inManagedObjectContext: context) as Folder
        var error:NSError?
        
        folderMO.name = name
        
        context.save(&error)
        
        return error
    }
    
    func findAll() -> [AnyObject]{
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: "caseInsensitiveCompare:")
        let fetchRequest = NSFetchRequest(entityName: "Folder")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var results = context.executeFetchRequest(fetchRequest, error: nil)!
        return results
    }
    
    
    func getDefaultFolder() -> AnyObject{
        
        let fetchRequest = NSFetchRequest(entityName: "Folder")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate =  NSPredicate(format: "id = 1")
        var results = context.executeFetchRequest(fetchRequest, error: nil)!
        
        if(results.count == 0){
            
            let defaultFolderMO = NSEntityDescription.insertNewObjectForEntityForName("Folder", inManagedObjectContext: context) as Folder
            var error:NSError?
            
            defaultFolderMO.name = "Downloads"
            
            context.save(&error)
            return defaultFolderMO
        }
        
        return results.first!
    }
}
