//
//  WishlistViewController.swift
//  freshness-tracker
//
//  Created by Kaley Leung on 4/9/20.
//  Copyright © 2020 Kaley Leung. All rights reserved.
//

import UIKit

class WishlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var wishlistTable: UITableView!
    
    @IBOutlet weak var wishlistAdd: UIButton!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appData.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = wishlistTable.dequeueReusableCell(withIdentifier: "wishlistCell") as? WishListItemCell {
            cell.itemLabel.text = appData.list[indexPath.row].name
            if appData.list[indexPath.row].checked {
                cell.checkButton.setImage(UIImage(named: "checked"), for: .normal)
                cell.itemLabel.textColor = UIColor(named: "DarkerGray")
            } else {
                cell.checkButton.setImage(UIImage(named: "unchecked"), for: .normal)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
   /*
   credit to:
   https://stackoverflow.com/questions/32004557/swipe-able-table-view-cell-in-ios-9
   */
   func tableView(_ tableView: UITableView,
                  trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
       // Write action code for the trash
       let TrashAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
           appData.removeItem(name: appData.list[indexPath.row].name)
           self.viewWillAppear(false)
           success(true)
       })
       TrashAction.backgroundColor = .red
       TrashAction.image = UIImage(systemName: "trash")


       return UISwipeActionsConfiguration(actions: [TrashAction])
   }
    
    override func viewWillAppear(_ animated: Bool) {
        wishlistTable.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        wishlistTable.dataSource = self
        wishlistTable.delegate = self
    }
    
}
