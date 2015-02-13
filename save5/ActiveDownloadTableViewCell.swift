//
//  ActiveDownloadTableViewCell.swift
//  save5
//
//  Created by José Carlos Sobrino on 31/01/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class ActiveDownloadTableViewCell: UITableViewCell {
    
    var circularProgress:DALabeledCircularProgressView?
    
    @IBOutlet weak var hostname: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ETA: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var remainingTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        circularProgress = DALabeledCircularProgressView(frame: progressView.bounds)
        circularProgress!.autoresizingMask = .FlexibleLeftMargin | .FlexibleRightMargin
        progressView.addSubview(circularProgress!)
        circularProgress!.roundedCorners = 1
       
        
        lookAndFeel()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func lookAndFeel(){
        
        //self.backgroundColor = LookAndFeel.style.orangeApple
        name.textColor = LookAndFeel.style.titleCellColor
        name.font = LookAndFeel.style.titleCellFont
        hostname.textColor = LookAndFeel.style.mainColor
        hostname.font = LookAndFeel.style.subtitleCellFont
        ETA.textColor = LookAndFeel.style.subtitleMiniCellColor
        ETA.font = LookAndFeel.style.subtitleMiniCellFont
        remainingTime.textColor = LookAndFeel.style.subtitleMiniCellColor
        remainingTime.font = LookAndFeel.style.subtitleMiniCellFont
   
        circularProgress!.trackTintColor = LookAndFeel.style.progressTrackColor
        circularProgress!.progressTintColor = LookAndFeel.style.progressColor
        circularProgress!.thicknessRatio = 0.2
        circularProgress!.progressLabel.font = LookAndFeel.style.progressTextFont
        circularProgress!.progressLabel.textColor = LookAndFeel.style.progressTextColor
        //layer.cornerRadius = 5
        layer.shadowOffset = CGSizeMake(1, 0)
        //layer.shadowRadius = 5
        //layer.borderWidth = 0.3
        //layer.borderColor = UIColor.grayColor().CGColor
        layer.shadowOpacity = 0.25
        layer.shadowColor = UIColor.blackColor().CGColor
          
    }

}
