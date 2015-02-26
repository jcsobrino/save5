//
//  save5.swift
//  save5
//
//  Created by José Carlos Sobrino on 13/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import Foundation
import CoreData

class Video: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var length: Int64
    @NSManaged var name: String
    @NSManaged var spaceOnDisk: Int64
    @NSManaged var thumbnailFilename: String
    @NSManaged var videoFilename: String
    @NSManaged var sourcePage: String
    @NSManaged var folder: save5.Folder

    
    struct entity {
    
        static let name = "Video"
    }
}
