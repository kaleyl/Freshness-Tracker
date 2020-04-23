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
    var image: UIImage?
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
        let apple = FoodEntry(name: "Apple", image: UIImage(named: "apple"), expireDate: Date())
        
        let orange = FoodEntry(name: "Orange", image: UIImage(named: "food"), expireDate: Date())
        self.tracker.append(apple)
        self.tracker.append(orange)
    }
 
    func addFoodEntry(food: FoodEntry) {
        self.tracker.append(food)
    }
    
    func addListEntry(item: ListEntry){
        self.list.append(item)
    }
    
    func removeFood(name: String) {
        for (index, food) in tracker.enumerated() {
            if (food.name == name) {
                tracker.remove(at: index)
                return
            }
        }
    }

}

/*
 credit to:
 https://stackoverflow.com/questions/24723431/swift-days-between-two-nsdates
 */
func calculateLeftDays(startDate: Date, endDate: Date) -> Int {
       let calendar = Calendar.current
       let components = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
       return components.day!
   }

