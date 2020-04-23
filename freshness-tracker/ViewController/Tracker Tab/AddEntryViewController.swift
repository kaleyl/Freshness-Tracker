//
//  AddEntryViewController.swift
//  freshness-tracker
//
//  Created by Kaley Leung on 4/9/20.
//  Copyright © 2020 Kaley Leung. All rights reserved.
//

import UIKit

class AddEntryViewController: UIViewController {
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var photoBtn: UIButton!
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var dateText: UITextField!
    
    @IBOutlet weak var estimateLabel1: UILabel!
    
    @IBOutlet weak var estimateLabel2: UILabel!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    private var datePicker: UIDatePicker!
    
    private var imagePickerController: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make estimatealabel invisible
        estimateLabel1.isHidden = true
        estimateLabel2.isHidden = true

        //set up date picker
        self.datePicker = UIDatePicker()
        createDatePicker()
        
        //set up image picker
        self.imagePickerController = UIImagePickerController()
        self.imagePickerController.delegate = self
        
    }
    
    @IBAction func photoBtnPressed(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
        
        present(imagePickerController,animated: true){
            print("Album Image Picker Presented")
        }
    }
    
    /*
     credit to:
     https://www.youtube.com/watch?v=8NngJrVFfUw
     */
    func createDatePicker(){
        //create toolboar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar Done button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnPressed))
        toolbar.setItems([doneBtn], animated: true)
        
        //assign toolbar
        dateText.inputAccessoryView = toolbar
        //bind date picker to text field
        datePicker.datePickerMode = .date
        dateText.inputView = datePicker
        
    }
    
    @objc func doneBtnPressed(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateText.text = dateFormatter.string(from: datePicker.date)
        
        //dismiss the date picker after select date
        self.view.endEditing(true)
        
        //update the estimated days left
        updateDaysLeft()
    }
    
    func updateDaysLeft(){
        
        let diff = calculateLeftDays(startDate: Date(), endDate: datePicker.date)
        print(diff)
        
        //check if input day is valid
        if(diff < 0){
            print("Input date is invalid: food has expired")
        }else{
            //update dayLabel
            estimateLabel1.isHidden = false
            dayLabel.text = String(diff)
            if(diff < 4){
                dayLabel.textColor = UIColor(named: "SoonYellow")
            }else{
                dayLabel.textColor = UIColor(named:"FreshGreen")
            }
            estimateLabel2.isHidden = false
        }
    }
    
    @IBAction func addToTrackerBtnPressed(_ sender: Any) {
        //create new food entry
        if let productName = nameText.text{
            if let productImg = photoView.image{
                let newFoodEntry = FoodEntry(name: productName, image: productImg, expireDate: datePicker.date)
                //add to Tracker
                appData.addFoodEntry(food: newFoodEntry)
            }else{
                print("Product image is required!")
            }
            print("Product name is required!")
        }
    }
}

extension AddEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[.originalImage] as? UIImage{
            photoView.image = img
            photoBtn.borderWidth = 0
        }
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}
