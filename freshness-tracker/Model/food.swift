//
//  food.swift
//  freshness-tracker
//
//  Created by Kaley Leung on 4/9/20.
//  Copyright © 2020 Kaley Leung. All rights reserved.
//

import Foundation
import UIKit

//global instance
var appData = AppData()

struct FoodEntry {
    var name: String
    var image: UIImage
    var expireDate: Date
}

struct ListEntry {
    var name: String
    var chekced: Bool
}


class AppData {
    var tracker: [FoodEntry]
    var list: [ListEntry]
    
    init() {
        self.tracker = []
        self.list = []
        
        //add some dummies
    }
 
    func addFoodEntry(food: FoodEntry) {
        self.tracker.append(food)
    }
    
    func addListEntry(item: ListEntry){
        self.list.append(item)
    }
}
