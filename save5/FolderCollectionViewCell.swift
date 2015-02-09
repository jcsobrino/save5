//
//  FolderCollectionViewCell.swift
//  save5
//
//  Created by José Carlos Sobrino on 05/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class FolderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lookAndFeel();
    }
    
    private func lookAndFeel(){
        
        name.textColor = LookAndFeel.style.titleCellColor
        name.font = LookAndFeel.style.titleCellFont
        info.textColor = LookAndFeel.style.subtitleMiniCellColor
        info.font = LookAndFeel.style.subtitleMiniCellFont
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
