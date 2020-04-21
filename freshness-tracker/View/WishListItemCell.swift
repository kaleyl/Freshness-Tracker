//
//  WishListItemCell.swift
//  freshness-tracker
//
//  Created by Kaley Leung on 4/19/20.
//  Copyright © 2020 Kaley Leung. All rights reserved.
//

import UIKit

class WishListItemCell: UITableViewCell {

    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
