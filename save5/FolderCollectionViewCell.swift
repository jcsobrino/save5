//
//  FolderCollectionViewCell.swift
//  save5
//
//  Created by José Carlos Sobrino on 05/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class FolderCollectionViewCell: UICollectionViewCell {

    var thumbnailImage:SWSnapshotStackView?
    
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var thumbnailView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lookAndFeel();
        
        thumbnailImage = SWSnapshotStackView(frame: thumbnailView.bounds)
        thumbnailImage!.autoresizingMask = .FlexibleLeftMargin | .FlexibleRightMargin
        thumbnailView.addSubview(thumbnailImage!)
      
    }
    
    private func lookAndFeel(){
        
        self.backgroundColor = UIColor.whiteColor()
      
    }
    
}
