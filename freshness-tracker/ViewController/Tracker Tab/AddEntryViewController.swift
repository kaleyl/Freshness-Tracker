//
//  AddEntryViewController.swift
//  freshness-tracker
//
//  Created by Kaley Leung on 4/9/20.
//  Copyright © 2020 Kaley Leung. All rights reserved.
//

import UIKit
import SearchTextField

class AddEntryViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //number of wheel in each pickerview
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch PickerViewTag(rawValue: pickerView.tag) {
            case .ExpiryType:
                print("Expiry Type")
                return expiryTypes.count
            default:
                 print("Time Unit")
                return timeUnits.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch PickerViewTag(rawValue: pickerView.tag) {
            case .ExpiryType:
                return expiryTypes[row] //dropdown item
            default:
                return timeUnits[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         //selected item, update textField
        switch PickerViewTag(rawValue: pickerView.tag) {
            case .ExpiryType:
                expiryText.text = expiryTypes[row]
            default:
                timeUnitText.text = timeUnits[row]
        }
    }
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var photoBtn: UIButton!
    
    @IBOutlet weak var nameText: SearchTextField!
    
    @IBOutlet weak var expiryText: UITextField!
    
    @IBOutlet weak var dateText: UITextField!
    
    @IBOutlet weak var timeUnitText: UITextField!
    
    @IBOutlet weak var estimateLabel1: UILabel!
    
    @IBOutlet weak var estimateLabel2: UILabel!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    private var datePicker: UIDatePicker!
    
    private var imagePickerController: UIImagePickerController!
    
    private var expiryPicker: UIPickerView!
    
    private var unitPicker: UIPickerView!
    
    private var expiryTypes: [String] = ["Best Before Date","Production Date","No Date Available"]
    
    private var timeUnits: [String] = ["days","months","years"]
    
    enum PickerViewTag: Int{
        case ExpiryType
        case TimeUnit
    }
    
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
        
        //set exipry date picker view
        self.expiryPicker = UIPickerView()
        createPickerView(pickerView: self.expiryPicker, textField: expiryText, tag:.ExpiryType)
        
        //set time unit picker view
        self.unitPicker = UIPickerView()
        createPickerView(pickerView: self.unitPicker, textField: timeUnitText,tag:.TimeUnit)
        
        //Autocomplete UITextField
        /*
            Credit to:
            https://github.com/apasccon/SearchTextField
         */
        nameText.filterStrings(appData.record)
        nameText.theme.font = UIFont(name: "Nunito Sans", size: 16)!
        nameText.theme.bgColor = UIColor.white
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
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateDoneBtnPressed))
        toolbar.setItems([doneBtn], animated: true)
        
        //assign toolbar
        dateText.inputAccessoryView = toolbar
        //bind date picker to text field
        datePicker.datePickerMode = .date
        dateText.inputView = datePicker
        
    }
    
    @objc func dateDoneBtnPressed(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateText.text = dateFormatter.string(from: datePicker.date)
        
        //dismiss the date picker after select date
        self.view.endEditing(true)
        
        //update the estimated days left
        updateDaysLeft()
    }
    
    /*
     credit to:
     https://medium.com/@raj.amsarajm93/create-dropdown-using-uipickerview-4471e5c7d898
     */
    func createPickerView(pickerView: UIPickerView, textField:UITextField, tag:PickerViewTag){
        pickerView.delegate = self
        pickerView.tag = tag.rawValue
        
        //create toolboar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
       
        //bar Done button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(pickerDoneBtnPressed))
        toolbar.setItems([doneBtn], animated: true)
               
        //assign toolbar
        textField.inputAccessoryView = toolbar
        //bind date picker to text field
        textField.inputView = pickerView
    }
    
    @objc func pickerDoneBtnPressed() {
          view.endEditing(true)
    }
    
    func updateDaysLeft(){
        
        let diff = calculateLeftDays(startDate: Date(), endDate: datePicker.date)
        print(diff)
        
        //check if input day is valid
        if(diff < 0){
            // Input date is invalid: food has expired
            errorHandleAlert(view: self, title: "Entered food has expired.", msg: "Please enter a valid expiry date.")
            //clean up textfield
            self.dateText.text = ""
            estimateLabel1.isHidden = true
            dayLabel.text = ""
            estimateLabel2.isHidden = true
        }else{
            //update dayLabel
            estimateLabel1.isHidden = false
            dayLabel.text = String(diff)
            dayLabel.textColor = getLeftDaysColor(daysLeft: diff)
            estimateLabel2.isHidden = false
        }
    }
    
    @IBAction func addToTrackerBtnPressed(_ sender: Any) {
        //check if all input is filled
        if(nameText.text == ""){
            errorHandleAlert(view: self, title: "Product name is required.", msg: "Please enter a Product name.")
        }
        
        let productName = nameText.text!.lowercased().capitalized
    
        if let productImg = photoView.image {
            let newFoodEntry = FoodEntry(name: productName, image: productImg, expireDate: datePicker.date, dateAdded: Date())
            //add to Tracker
            appData.addFoodEntry(food: newFoodEntry)
        } else {
             errorHandleAlert(view: self, title: "Product image is required.", msg: "Please enter a Product image.")
        }
    }
}

func errorHandleAlert(view:AddEntryViewController,title:String,msg:String){
    let alert = UIAlertController(title: title,
                                    message: msg,
                                    preferredStyle: .alert)
    let okay = UIAlertAction(title: "OK", style: .destructive, handler: { (action) -> Void in })
    alert.addAction(okay)
    view.present(alert, animated: true, completion: nil)
    
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
