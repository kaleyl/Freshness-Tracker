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
    var dateAdded: Date
}

struct ListEntry {
    var name: String
    var checked: Bool
}


class AppData {
    var tracker: [FoodEntry]
    var list: [ListEntry]
    var favorite : [FoodEntry]
    
    init() {
        self.tracker = []
        self.list = []
        self.favorite = []
        
        //add some dummies
        //tracker list
        let date = Date()
        var components = DateComponents()
        components.setValue(1, for: .month)
      
        let apple = FoodEntry(name: "Apple", image: UIImage(named: "apple"), expireDate: Date(), dateAdded: Date())
        let bread = FoodEntry(name: "Bread", image: UIImage(named: "food"), expireDate:Calendar.current.date(byAdding: components, to: date)!, dateAdded: Date())
        let orange = FoodEntry(name: "Orange", image: UIImage(named: "food"), expireDate: Date(), dateAdded: Date())
       
        
        self.tracker.append(apple)
        self.tracker.append(bread)
        self.tracker.append(orange)
        
        //wish list
        let freshMilk = ListEntry(name: "Fresh Milk", checked: false)
        let pineappleSausage = ListEntry(name: "Pineapple Sausage", checked: true)
        
        self.list.append(freshMilk)
        self.list.append(pineappleSausage)
    }
 
    func addFoodEntry(food: FoodEntry) {
        self.tracker.append(food)
    }
    
    func addListEntry(item: ListEntry) {
        self.list.append(item)
    }
    
    func addToFavorite(food: FoodEntry) {
        self.favorite.append(food)
    }
    
    func removeFood(name: String) {
        for (index, food) in tracker.enumerated() {
            if (food.name == name) {
                tracker.remove(at: index)
                return
            }
        }
    }
    
    func removeItem(name: String) {
        for (index, item) in list.enumerated() {
            if (item.name == name) {
                list.remove(at: index)
                return
            }
        }
    }
    
    func changeItemStatus(name: String) {
        for (index, item) in list.enumerated() {
            if (item.name == name) {
                if (item.checked) {
                    list.remove(at: index)
                    let unchekedItem = ListEntry(name: name, checked: false)
                    list.append(unchekedItem)
                } else {
                    list.remove(at: index)
                    let checkedItem = ListEntry(name: name, checked: true)
                    list.append(checkedItem)
                }
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


func getLeftDaysColor(daysLeft:Int) -> UIColor {
    if(daysLeft <= 0){
        return UIColor(named: "ExpiredRed")!
    }else if(daysLeft < 4){
        return UIColor(named: "SoonYellow")!
    }else{
        return UIColor(named: "FreshGreen")!
    }
}

func sortExpireDate(this: FoodEntry, that: FoodEntry) -> Bool {
    let thisDate = calculateLeftDays(startDate: Date(), endDate: this.expireDate)
    let thatDate = calculateLeftDays(startDate: Date(), endDate: that.expireDate)
    return thisDate < thatDate
}


func sortDateAdded(this: FoodEntry, that: FoodEntry) -> Bool {
    return this.dateAdded < that.dateAdded
}
