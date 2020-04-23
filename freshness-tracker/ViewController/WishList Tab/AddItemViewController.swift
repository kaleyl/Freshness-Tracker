//
//  AddItemViewController.swift
//  freshness-tracker
//
//  Created by Yutong Zhou on 4/22/20.
//  Copyright © 2020 Kaley Leung. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var newItem: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? WishlistViewController{
            if let itemName = newItem.text {
                let item = ListEntry(name: itemName, chekced: false)
                dest.wishlist.list.append(item)
            }
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
