//
//  VideoVO.swift
//  save5
//
//  Created by José Carlos Sobrino on 31/01/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class VideoVO: NSObject {
   
    var id: String?
    var name: String?
    var sourcePage: String?
    var thumbnailFilename: String?
    var spaceOnDisk: Float?
    var length: Int64?
    var videoFilename: String?
    var videoURL: NSURL?
    var folder: Folder?

}
