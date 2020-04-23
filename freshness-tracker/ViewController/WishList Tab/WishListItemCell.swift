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
    
    
    /*
     credit to:
     https://stackoverflow.com/questions/44933283/how-to-check-if-a-button-has-this-image
     */
    @IBAction func checkButtonPressed(_ sender: Any) {
        if checkButton.image(for: .normal)!.pngData() == UIImage(named: "unchecked")!.pngData() {
            let image = UIImage(named: "checked")!
            checkButton.setImage(image, for: .normal)
            itemLabel.textColor = UIColor(named: "DarkerGray")
            appData.changeItemStatus(name: itemLabel.text!)
        } else if checkButton.image(for: .normal)!.pngData() == UIImage(named: "checked")!.pngData() {
            let image = UIImage(named: "unchecked")!
            checkButton.setImage(image, for: .normal)
            itemLabel.textColor = UIColor(named: "Black")
            appData.changeItemStatus(name: itemLabel.text!)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
