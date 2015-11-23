//
//  WebRecentSearchItem.swift
//  save5
//
//  Created by José Carlos Sobrino on 23/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import Foundation
import CoreData

class WebRecentSearchItem: NSManagedObject {
   
    @NSManaged var url: String
    @NSManaged var title: String
    @NSManaged var lastAccess: NSDate

    struct entity {
        
        static let name = "WebRecentSearchItem"
    }
}
