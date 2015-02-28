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
   
    class var sharedInstance : FolderDAO {
        
        struct Static {
            static let instance : FolderDAO = FolderDAO()
        }
        return Static.instance
    }
    
    private override init(){
        
    }
    
    func createFolder(name:String) -> Folder {
        
        let folder = NSEntityDescription.insertNewObjectForEntityForName(Folder.entity.name, inManagedObjectContext: context) as Folder
        
        folder.name = name
        
        commit()
        
        return folder
    }
    
    func findAll() -> [AnyObject]{
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: "caseInsensitiveCompare:")
        let fetchRequest = NSFetchRequest(entityName: Folder.entity.name)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var results = context.executeFetchRequest(fetchRequest, error: nil)!
    
        return results
    }
    
    
    func getDefaultFolder() -> Folder {
        
        let fetchRequest = NSFetchRequest(entityName: Folder.entity.name)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate =  NSPredicate(format: "defaultFolder = true")
        var results = context.executeFetchRequest(fetchRequest, error: nil)!
        
        if(results.count == 0){
            
            let defaultFolder = NSEntityDescription.insertNewObjectForEntityForName(Folder.entity.name, inManagedObjectContext: context) as Folder
            
            defaultFolder.name = "Downloads"
            defaultFolder.defaultFolder = true
            
            commit()
            return defaultFolder
        }
        
        return results.first! as Folder
    }
    
    func createFetchedResultControllerAllFolders(delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: "caseInsensitiveCompare:")
        let fetchRequest = NSFetchRequest(entityName: Folder.entity.name)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [sortDescriptor]
        
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
