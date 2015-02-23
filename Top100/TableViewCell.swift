//
//  TableViewCell.swift
//  Top100
//
//  Created by ninja on 2/19/15.
//  Copyright (c) 2015 An Nguyen. All rights reserved.
//

import UIKit
import Foundation

class TableViewCell: UITableViewCell {

    
    @IBOutlet var SongImg: UIImageView!
    
    @IBOutlet var SongTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       SongImg.contentMode = UIViewContentMode.ScaleAspectFit
        /*
        SongImg.autoresizingMask = ( UIViewAutoresizing.FlexibleBottomMargin
            | UIViewAutoresizing.FlexibleHeight
            | UIViewAutoresizing.FlexibleLeftMargin
            | UIViewAutoresizing.FlexibleRightMargin
            | UIViewAutoresizing.FlexibleTopMargin
            | UIViewAutoresizing.FlexibleWidth );*/
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
