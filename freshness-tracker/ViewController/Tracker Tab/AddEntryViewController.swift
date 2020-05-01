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
                return expiryTypes.count
            default:
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
    
    @IBOutlet weak var calendarIcon: UIImageView!
    
    @IBOutlet weak var dateText: UITextField!
    
    @IBOutlet weak var shelfLabel: UILabel!
    
    @IBOutlet weak var shelfLifeText: UITextField!
    
    @IBOutlet weak var timeUnitText: UITextField!
    
    @IBOutlet weak var estimateLabel1: UILabel!
    
    @IBOutlet weak var estimateLabel2: UILabel!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    private var datePicker: UIDatePicker!
    
    private var imagePickerController: UIImagePickerController!
    
    private var expiryPicker: UIPickerView!
    
    private var unitPicker: UIPickerView!
    
    private var shelfLife: Int!
    
    private var daysLeft: Int!
    
    private var expiryTypes: [String] = ["Best Before Date","Production Date","No Date Available"]
    
    private var timeUnits: [String] = ["days","weeks","months","years"]
    
    enum PickerViewTag: Int{
        case ExpiryType
        case TimeUnit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up text field UI
        setTextFieldBorder(textField: nameText)
        setTextFieldBorder(textField: dateText)
        setTextFieldBorder(textField: shelfLifeText)
        
        //set up image picker
        self.imagePickerController = UIImagePickerController()
        self.imagePickerController.delegate = self
    
        //Autocomplete UITextField
        /*
            Credit to:
            https://github.com/apasccon/SearchTextField
         */
        nameText.filterStrings(appData.record)
        nameText.theme.font = UIFont(name: "Nunito Sans", size: 16)!
        nameText.theme.bgColor = UIColor.white
    
        
        //set exipry date picker view
        self.expiryPicker = UIPickerView()
        createPickerView(pickerView: self.expiryPicker, textField: expiryText, tag:.ExpiryType)
        
        //set up date picker
        self.datePicker = UIDatePicker()
        createDatePicker()
        calendarIcon.tintColor = UIColor(named:"LighterGray")!
        dateText.isUserInteractionEnabled = false
        
        //set time unit picker view
        self.unitPicker = UIPickerView()
        createPickerView(pickerView: self.unitPicker, textField: timeUnitText,tag:.TimeUnit)
        shelfLabel.textColor = UIColor(named:"LighterGray")!
        shelfLifeText.isUserInteractionEnabled = false;
        timeUnitText.isUserInteractionEnabled = false;
        
        //make estimatealabel invisible
        estimateLabel1.isHidden = true
        estimateLabel2.isHidden = true
        
        //set up gesture
               let tapRecognizer = UITapGestureRecognizer()
               tapRecognizer.addTarget(self, action: #selector(didTapView))
               self.view.addGestureRecognizer(tapRecognizer)
        
        /*
             move up view while typing using keyboard
             credit to:
          https://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
                         
        */
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    @objc func didTapView(){
      self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func setTextFieldBorder(textField:UITextField){
        let nameTextLine = CALayer()
        nameTextLine.frame = CGRect(x: 0.0, y: textField.frame.height - 5, width: textField.frame.width, height: 1.0)
        nameTextLine.backgroundColor = UIColor(named:"LighterGray")!.cgColor
        textField.borderStyle = UITextField.BorderStyle.none
        textField.layer.addSublayer(nameTextLine)
        
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
        dateText.text = dateFormatter.string(from: datePicker.date)
        
        //dismiss the date picker after select date
        self.view.endEditing(true)
        
        if(expiryText.text == expiryTypes[0]){
            //best before
            updateDaysLeft()
        }
    }

    func createPickerView(pickerView: UIPickerView, textField:UITextField, tag:PickerViewTag){
        pickerView.delegate = self
        pickerView.tag = tag.rawValue
        
        //create toolboar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar Done button
        if(tag == .ExpiryType){
            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(expiryDoneBtnPressed))
             toolbar.setItems([doneBtn], animated: true)
        }else{
            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(timeUnitDoneBtnPressed))
            toolbar.setItems([doneBtn], animated: true)
        }
        //assign toolbar
        textField.inputAccessoryView = toolbar
        //bind date picker to text field
        textField.inputView = pickerView
    }
    
    @objc func expiryDoneBtnPressed() {
        view.endEditing(true)
        
        //disable estimated statement
        estimateLabel1.isHidden = true
        estimateLabel2.isHidden = true
        dayLabel.text = ""
        
        let selectedType = expiryText.text!
        
        //update form options
        if(selectedType == expiryTypes[0]){
            //enable
            calendarIcon.tintColor = UIColor(named: "TrackGreen")
            dateText.isUserInteractionEnabled = true
            dateText.text = ""
            
            self.datePicker.minimumDate = Date()
            self.datePicker.maximumDate = nil
            
            //disable
            shelfLabel.textColor = UIColor(named: "LighterGray")
            shelfLifeText.text = ""
            shelfLifeText.isUserInteractionEnabled = false
            timeUnitText.text = ""
            timeUnitText.isUserInteractionEnabled = false
            
        }else if(selectedType == expiryTypes[1]){
            //enable
            calendarIcon.tintColor = UIColor(named: "TrackGreen")
            dateText.isUserInteractionEnabled = true
            dateText.text = ""
            
            self.datePicker.minimumDate = nil
            self.datePicker.maximumDate = Date()
            
            shelfLabel.textColor = UIColor(named: "TrackGreen")
            shelfLifeText.isUserInteractionEnabled = true
            timeUnitText.isUserInteractionEnabled = true
            shelfLifeText.text = ""
            timeUnitText.text = ""
        }else{
            //enable
            shelfLabel.textColor = UIColor(named: "TrackGreen")
            shelfLifeText.isUserInteractionEnabled = true
            timeUnitText.isUserInteractionEnabled = true
            shelfLifeText.text = ""
            timeUnitText.text = ""
            
            //disable
            calendarIcon.tintColor = UIColor(named: "LighterGray")
            dateText.isUserInteractionEnabled = false
            dateText.text = ""
            
        }
    }
    
    @objc func timeUnitDoneBtnPressed() {
        view.endEditing(true)
        
        let shelfLifeDuration = shelfLifeText.text!
        let timeUnit = timeUnitText.text
        
        if(shelfLifeDuration != ""){
            let duration = Int(shelfLifeDuration)!
            if(timeUnit == timeUnits[0]){
                self.shelfLife = duration
            }else if(timeUnit == timeUnits[1]){
                self.shelfLife = duration * 7
            }else if(timeUnit == timeUnits[2]){
                self.shelfLife = duration * 30
            }else{
                self.shelfLife = duration * 365
            }
            updateDaysLeft()
        }else{
            errorHandleAlert(view: self, title: "Shelf life duration is required.", msg: "Please enter the shelf life.")
            timeUnitText.text = ""
        }
    }
    
    func updateDaysLeft(){
        var dateDiff: Int!
        
        let selectedType = expiryText.text
        
        if(selectedType == expiryTypes[0]){
            //best before
            dateDiff = calculateLeftDays(startDate: Date(), endDate: datePicker.date)
            self.daysLeft = dateDiff
        }else if(selectedType == expiryTypes[1]){
            //production
            dateDiff = calculateLeftDays(startDate: datePicker.date, endDate: Date())
            self.daysLeft = self.shelfLife - dateDiff
            if(self.daysLeft < 0){
                errorHandleAlert(view: self, title: "Entered food has expired.", msg: "Please enter a valid expiry date.")
                dateText.text = ""
                shelfLifeText.text = ""
                timeUnitText.text = ""
                return
            }
        }else{
            //no date availabel
            self.daysLeft = self.shelfLife
        }
        //update dayLabel
        estimateLabel1.isHidden = false
        dayLabel.text = String(daysLeft)
        dayLabel.textColor = getLeftDaysColor(daysLeft: daysLeft)
        estimateLabel2.isHidden = false
    }
    
    @IBAction func addToTrackerBtnPressed(_ sender: Any) {
        //check if all input is filled
        if(nameText.text == ""){
            errorHandleAlert(view: self, title: "Product name is required.", msg: "Please enter a product name.")
        }else{
            if(expiryText.text == ""){
                errorHandleAlert(view: self, title: "The type of expiry date is required.", msg: "Please select one expiry date.")
            }else{
                if(expiryText.text != expiryTypes[2] && dateText.text == "" ){
                        //best before, production: enable date
                    errorHandleAlert(view: self, title: "The date is required.", msg: "Please choose a date.")
                }else if(expiryText.text != expiryTypes[0] && (shelfLifeText.text == "" || timeUnitText.text == "")){
                        //production,shelf time: enable shelf life
                    errorHandleAlert(view: self, title: "The time unit for shelf life date is required.", msg: "Please select a time unit.")
                }else{
                    let productName = nameText.text!.lowercased().capitalized
                    let days = self.daysLeft + 1
                    let expireDate = Date().addingTimeInterval(TimeInterval(60 * 60 * 24 * days))
                
                    if let productImg = photoView.image {
                        let newFoodEntry = FoodEntry(name: productName, image: productImg, expireDate: expireDate, dateAdded: Date())
                        //add to Tracker
                        appData.addFoodEntry(food: newFoodEntry)
                    } else {
                        errorHandleAlert(view: self, title: "Product image is required.", msg: "Please enter a Product image.")
                    }
                }
            }
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
