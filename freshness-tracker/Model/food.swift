//
//  food.swift
//  freshness-tracker
//
//  Created by Kaley Leung on 4/9/20.
//  Copyright © 2020 Kaley Leung. All rights reserved.
//

import Foundation
import UIKit
import Firebase

//global instance
var appData = AppData()
let db = Firestore.firestore()
let storage = Storage.storage()

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
    var record: [String]
    
    init() {
        self.tracker = []
        self.list = []
        self.record = [] //used for autocomplete
        
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
        
        self.record.append(apple.name)
        self.record.append(bread.name)
        self.record.append(orange.name)
        
        //wish list
        let freshMilk = ListEntry(name: "Fresh Milk", checked: false)
        let pineappleSausage = ListEntry(name: "Pineapple Sausage", checked: true)
        
        self.list.append(freshMilk)
        self.list.append(pineappleSausage)
    }
 
    func addFoodEntry(food: FoodEntry) {
        print("add food")
        self.tracker.append(food)
        //check if already contains name
        if(!self.record.contains(food.name)){
            self.record.append(food.name)
        }
        
        //add to firebase
    }
    
    func addListEntry(item: ListEntry) {
        self.list.append(item)
        
        print("add list")
        
        //add to firebase
        let name = item.name
        let checked = item.checked

        var ref: DocumentReference? = nil
        ref = db.collection("wishList")
            .addDocument(data:[
                "name": name,
                "checked": checked]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")

                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
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
    
    func sortItems() {
        appData.list.sort{
            if ($0.checked != $1.checked) {
                return !$0.checked && $1.checked
            } else {
                return $0.name < $1.name
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
                    self.sortItems()
                } else {
                    list.remove(at: index)
                    let checkedItem = ListEntry(name: name, checked: true)
                    list.append(checkedItem)
                    self.sortItems()
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

func fetchTrackerData(){
    
}

func fetchWishListData(){
    db.collection("wishList").getDocuments(){
        (items, err) in if let err = err{
            print("Error getting documents: \(err)")
        }else{
            for item in items!.documents {
                let name = item.data()["name"] as! String
                let checked = item.data()["checked"] as! Bool
                
                appData.list.append(ListEntry(name: name,checked: checked))
            }
        }
    }
}
