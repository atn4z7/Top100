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

    private var SongID = NSString(string:"0")
    @IBOutlet private var SongImg: UIImageView!
    
    @IBOutlet private var SongTitle: UILabel!
    
    public func setImg(data : NSData){
        SongImg.image = UIImage(data: data)
    }
    
    public func setTitle(title : String){
        SongTitle.text = title
    }
    
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
