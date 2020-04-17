//
//  food.swift
//  freshness-tracker
//
//  Created by Kaley Leung on 4/9/20.
//  Copyright © 2020 Kaley Leung. All rights reserved.
//

import Foundation
import UIKit

struct FoodEntry {
    var name: String
    var daysLeft: Int
    var image: UIImage
}


class FoodData {
    var foods: [FoodEntry]
    init(name: String, days: Int) {
        self.foods = []
    }
 
    func addEntry(food: FoodEntry) {
        self.foods.append(contentsOf: food)
    }
}
