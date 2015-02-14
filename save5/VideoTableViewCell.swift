//
//  VideoTableViewCell.swift
//  save5
//
//  Created by José Carlos Sobrino on 31/01/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var hostname: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var format: UILabel!
    @IBOutlet weak var length: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var iconLength: UILabel!
    @IBOutlet weak var iconSize: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lookAndFeel()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func lookAndFeel(){
        
        name.textColor = LookAndFeel.style.titleCellColor
        name.font = LookAndFeel.style.titleCellFont
        hostname.textColor = LookAndFeel.style.mainColor
        hostname.font = LookAndFeel.style.subtitleCellFont
        length.textColor = LookAndFeel.style.subtitleMiniCellColor
        length.font = LookAndFeel.style.subtitleMiniCellFont
        size.textColor = LookAndFeel.style.subtitleMiniCellColor
        size.font = LookAndFeel.style.subtitleMiniCellFont
        
        let aux = LookAndFeel.icons.playVideoCell
        aux.addAttribute(NSForegroundColorAttributeName, value: LookAndFeel.style.subtitleMiniCellColor)
        let aux2 = LookAndFeel.icons.spaceOnDisk
        aux2.addAttribute(NSForegroundColorAttributeName, value: LookAndFeel.style.subtitleMiniCellColor)
        
        
        iconLength.attributedText = aux.attributedString()
        iconSize.attributedText = aux2.attributedString()
    
    }
    
    
    
}
