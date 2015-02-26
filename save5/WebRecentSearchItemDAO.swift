//
//  WebRecentSearchItemDAO.swift
//  save5
//
//  Created by José Carlos Sobrino on 23/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit
import CoreData

class WebRecentSearchItemDAO: BaseDAO {
 
    let maxSearches = 20
    
    class var sharedInstance : WebRecentSearchItemDAO {
        
        struct Static {
            static let instance : WebRecentSearchItemDAO = WebRecentSearchItemDAO()
        }
        return Static.instance
    }
    
    private override init(){
        
    }
    
    func addItem(URL: String, title: String) -> WebRecentSearchItem {
        
        var webRecentSearchItemMO = findByURL(URL)
        
        if webRecentSearchItemMO != nil {
            
            webRecentSearchItemMO!.lastAccess = NSDate()
            
        } else {
       
            if(countItems() < maxSearches){
                
                webRecentSearchItemMO = NSEntityDescription.insertNewObjectForEntityForName(WebRecentSearchItem.entity.name, inManagedObjectContext: context) as WebRecentSearchItem
            
            } else {
                
                webRecentSearchItemMO = lastAccessItem()
            }
            
            webRecentSearchItemMO!.url = URL
            webRecentSearchItemMO!.title = title
            webRecentSearchItemMO!.lastAccess = NSDate()
        }
        
        commit()
        
        return webRecentSearchItemMO!
    }
    
    func findItems(string: String) -> [WebRecentSearchItem]{
        
        let fetchRequest = NSFetchRequest(entityName: WebRecentSearchItem.entity.name)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastAccess", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "url contains[cd] %@ OR title contains[cd] %@", string, string)
        
        return context.executeFetchRequest(fetchRequest, error: nil)! as [WebRecentSearchItem]
    }
    
    func findByURL(URL: String) -> WebRecentSearchItem? {
        
        let fetchRequest = NSFetchRequest(entityName: WebRecentSearchItem.entity.name)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "url == %@", URL)
        
        let results = context.executeFetchRequest(fetchRequest, error: nil)!
        
        return results.first as? WebRecentSearchItem
    }
    
    func countItems() -> Int {

        let fetchRequest = NSFetchRequest(entityName: WebRecentSearchItem.entity.name)
        fetchRequest.returnsObjectsAsFaults = false
        
        return context.countForFetchRequest(fetchRequest, error: nil)
    }
    
    func lastAccessItem() -> WebRecentSearchItem? {
       
        let fetchRequest = NSFetchRequest(entityName: WebRecentSearchItem.entity.name)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastAccess", ascending: false)]
        
        let results = context.executeFetchRequest(fetchRequest, error: nil)!
        
        return results.first as? WebRecentSearchItem
    }
    
    
    func clear(){
        
    }
   
}
