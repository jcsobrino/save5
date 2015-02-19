//
//  Folder.swift
//  save5
//
//  Created by José Carlos Sobrino on 31/01/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import Foundation
import CoreData

class Folder: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var defaultFolder: Bool
    @NSManaged var videos: NSOrderedSet

    var spaceOnDisk: Float {
     
        get {
           
            var sumSpace:Float = 0
            videos.enumerateObjectsUsingBlock { (elem, idx, stop) -> Void in
                
                sumSpace += elem.spaceOnDisk
            }
            
            return sumSpace
        }
    }
}
