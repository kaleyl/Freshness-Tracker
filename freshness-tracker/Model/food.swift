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
let dateFormatter : DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yyyy"
    return formatter
}()

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
        var componentsEgg = DateComponents()
        componentsEgg.setValue(1, for: .month)
        var componentsMilk = DateComponents()
        componentsMilk.setValue(3, for: .day)
      
        let apple = FoodEntry(name: "Apple", image: UIImage(named: "apple"), expireDate: Date(), dateAdded: Date())
        let bread = FoodEntry(name: "Egg", image: UIImage(named: "egg"), expireDate:Calendar.current.date(byAdding: componentsEgg, to: date)!, dateAdded: Date())
        let orange = FoodEntry(name: "Milk", image: UIImage(named: "milk"), expireDate: Calendar.current.date(byAdding: componentsMilk, to: date)!, dateAdded: Date())
       
        
        self.tracker.append(apple)
        self.tracker.append(bread)
        self.tracker.append(orange)
        
        self.record.append(apple.name)
        self.record.append(bread.name)
        self.record.append(orange.name)
        
        //wish list
        let freshMilk = ListEntry(name: "Fresh Milk", checked: false)
        let pineappleSausage = ListEntry(name: "Pineapple Sausage", checked: false)
        
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
        let imageID = UUID.init().uuidString
        let expireDate = dateFormatter.string(from: food.expireDate)
        let dateAdded = dateFormatter.string(from: food.dateAdded)
        
        let storageRef = storage.reference(withPath: "\(imageID).jpg")
        guard let imageData = food.image!.jpegData(compressionQuality: 0.75) else {return}
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        storageRef.putData(imageData)
        
        db.collection("tracker").document(food.name)
            .setData([
                "name":food.name,
                "imageID": imageID,
                "expireDate":expireDate,
                "dateAdded":dateAdded
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Tracker added with Name: \(food.name)")
                }
            }
    }
    
    func addListEntry(item: ListEntry) {
        if(!self.list.contains(where: {$0.name == item.name})){
            self.list.append(item)
            print("add list")
        
        //add to firebase
        db.collection("wishList").document(item.name)
            .setData([
                "name": item.name,
                "checked": item.checked]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")

                    } else {
                        print("Wish List added with ID: \(item.name)")
                    }
                }
        } else {
            print("Item already in wish list")
        }
    }
    
    func removeFood(name: String) {
        for (index, food) in tracker.enumerated() {
            if (food.name == name) {
                tracker.remove(at: index)
                //remove from firebase
                db.collection("tracker").document(food.name).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Tracker \(food.name) successfully removed!")
                    }
                }
                return
            }
        }
    }
    
    func ifTrackerEmpty() -> Bool{
        return self.tracker.count == 3
    }
    
    func ifListEmpty() -> Bool{
        return self.list.count == 2
    }
    
    func removeItem(name: String) {
        for (index, item) in list.enumerated() {
            if (item.name == name) {
                list.remove(at: index)
                db.collection("wishList").document(item.name).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Tracker \(item.name) successfully removed!")
                    }
                }
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

func fetchTrackerData(completion: @escaping(Bool)->()){
   db.collection("tracker").getDocuments(){
       (foods, err) in if let _ = err {
           completion(false)
       }else{
            for food in foods!.documents {
                let name = food.data()["name"] as! String
                let imageID = food.data()["imageID"] as! String
                let expireDateStr = food.data()["expireDate"] as! String
                let addedDateStr = food.data()["dateAdded"] as! String
            
                let expireDate = dateFormatter.date(from: expireDateStr)!
                let dateAdded = dateFormatter.date(from: addedDateStr)!
            
                let storageRef = storage.reference(withPath: "\(imageID).jpg")
                storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
                    if error != nil {
                        print("Fail to fetch tracker image from firebase storage")
                    }else{
                       
                        print("fetching data")
                        if let data = data {
                            let image = UIImage(data: data)
                            appData.tracker.append(FoodEntry(name: name, image: image, expireDate: expireDate, dateAdded: dateAdded))
                            if(!appData.record.contains(name)){
                            appData.record.append(name)
                            }
                        }
                         completion(true)
                    }
                }
            }
        
        
      }
   }
}

func fetchWishListData(completion: @escaping(Bool)->()){
    db.collection("wishList").getDocuments(){
        (items, err) in if let _ = err {
            completion(false)
        }else{
            for item in items!.documents {
                let name = item.data()["name"] as! String
                let checked = item.data()["checked"] as! Bool
                
                appData.list.append(ListEntry(name: name,checked: checked))
            }
            completion(true)
        }
    }
}
