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
    @IBAction func doneButtonPressed(_ sender: Any) {
        if let itemName = newItem.text {
            if itemName != "" {
                let item = ListEntry(name: itemName, checked: false)
                appData.list.append(item)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? UITabBarController{
            dest.selectedIndex = 1
        }
    }
}
