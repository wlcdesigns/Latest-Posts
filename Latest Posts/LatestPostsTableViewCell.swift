//
//  LatestPostsTableViewCell.swift
//  Latest Posts
//
//  Created by wlc on 7/15/15.
//  Copyright (c) 2015 wLc Designs. All rights reserved.
//

import UIKit

class LatestPostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
