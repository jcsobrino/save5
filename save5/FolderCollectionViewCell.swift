//
//  FolderCollectionViewCell.swift
//  save5
//
//  Created by José Carlos Sobrino on 05/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class FolderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var numVideos: UILabel!
    @IBOutlet weak var spaceOnDisk: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lookAndFeel();
    }
    
    private func lookAndFeel(){
        
        name.textColor = LookAndFeel.style.titleCellColor
        name.font = LookAndFeel.style.titleCellFont
        numVideos.textColor = LookAndFeel.style.subtitleMiniCellColor
        numVideos.font = LookAndFeel.style.subtitleMiniCellFont
        spaceOnDisk.textColor = LookAndFeel.style.subtitleMiniCellColor
        spaceOnDisk.font = LookAndFeel.style.subtitleMiniCellFont
        thumbnail.layer.borderColor = LookAndFeel.style.thumbnailBorderColor.CGColor
        thumbnail.layer.borderWidth = LookAndFeel.style.thumbnailBorderWidth
    }
    
    func deleteFolder(){
    
        let cellCollectionView = self.superview as UICollectionView
        
        cellCollectionView.delegate?.collectionView!(cellCollectionView, performAction: "deleteFolder", forItemAtIndexPath: cellCollectionView.indexPathForCell(self)!, withSender: self)
    }
    
    func renameFolder(){
        
        let cellCollectionView = self.superview as UICollectionView
        
        cellCollectionView.delegate?.collectionView!(cellCollectionView, performAction: "renameFolder", forItemAtIndexPath: cellCollectionView.indexPathForCell(self)!, withSender: self)
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
    
        return contains(["deleteFolder", "renameFolder"], action.description)
        
    }
}
