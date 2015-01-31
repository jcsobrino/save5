//
//  Video.swift
//  save5
//
//  Created by José Carlos Sobrino on 31/01/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import Foundation
import CoreData

class Video: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var thumbnailFilename: String
    @NSManaged var spaceOnDisk: Float
    @NSManaged var length: Int64
    @NSManaged var videoFilename: String
    @NSManaged var folder: Folder

}
