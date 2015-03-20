//
//  BaseDAO.swift
//  save5
//
//  Created by José Carlos Sobrino on 31/01/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit
import CoreData

class BaseDAO: NSObject {
   
    
    var context:NSManagedObjectContext {
        
        var delegate = UIApplication.sharedApplication().delegate as AppDelegate
        return delegate.managedObjectContext!
    }
    
    func deleteObject(object: NSManagedObject){
        
        context.deleteObject(object)
        commit()
    }
    
    func updateObject(object: NSManagedObject){
        
        commit()
    }
    
    func commit(){
    
        var error : NSError?
        
        if(!context.save(&error) ) {
            
            
            abort()
        }
    }
    
}
