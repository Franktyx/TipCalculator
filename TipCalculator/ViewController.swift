//
//  ViewController.swift
//  TipCalculator
//
//  Created by Yuxiang Tang on 2/20/16.
//  Copyright © 2016 Yuxiang Tang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    var currentNumber: Double = 0
    var tipPercent: Double = 0.15
    
    var inputTextField: UITextField!
    var inputToolBar: UIToolbar!
    
    var tipLabel: UILabel!
    var tipAmountLabel: UILabel!
    var totalLabel: UILabel!
    var totalAmountLabel: UILabel!
    
    var tipPercentSlider: UISlider!
    
    
    var pickerLabel: UILabel!
    var numberOfPartyPicker: UIPickerView!
    
    var pickerDataSource = ["1 🤓", "2 🙄" ,"3 👪", "4 👨‍👩‍👧‍👦", "5️⃣","6️⃣","7️⃣","8️⃣","9️⃣","🔟"]
    
    var individualAmountLabel: UILabel!
    var individualAmount: UILabel!
    
    var individualTipLabel:UILabel!
    var individualTip: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 68 / 255, green: 206 / 255, blue: 246 / 255, alpha: 1.0)

        
        self.navigationItem.title = "Tip Calculator"
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 238 / 255, green: 222 / 255, blue: 176 / 255, alpha: 1.0)

        self.textFieldSetup()
        
        self.labelSetup()
        
        self.sliderSetup()
        
        self.pickerSetup()
        
        self.individualLabelSetup()
        
    }
    
    func textFieldSetup(){
        self.inputTextField = UITextField()
        self.inputTextField.frame = CGRectMake(10, 100, self.screenWidth - 20, 100)
        self.inputTextField.placeholder = "$0.00"
        self.view.addSubview(self.inputTextField)
        self.inputTextField.delegate = self
        self.inputTextField.font = UIFont.boldSystemFontOfSize(40)
        self.inputTextField.textAlignment = .Right
        self.inputTextField.keyboardType = .DecimalPad
        self.inputTextField.tintColor = UIColor.blueColor()
        var rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "rightBarButtonItemOnClick:")
        
        self.inputToolBar = UIToolbar()
        self.inputToolBar.frame = CGRectMake(0, 0, self.screenWidth, 40)
        self.inputToolBar.barStyle = .Default
        self.inputToolBar.items = [rightBarButtonItem]
        self.inputTextField.inputAccessoryView = self.inputToolBar
        
    }
    
    func labelSetup(){
        self.tipAmountLabel = UILabel()
        self.tipAmountLabel.frame = CGRectMake(self.screenWidth - 100, self.inputTextField.frame.origin.y + self.inputTextField.frame.size.height + 10, 100, 40)
        self.tipAmountLabel.text = "$0.00"
        self.tipAmountLabel.textAlignment = .Right
        self.view.addSubview(self.tipAmountLabel)
        
        
        self.tipLabel = UILabel()
        self.tipLabel.frame = CGRectMake(self.tipAmountLabel.frame.origin.x - 100, self.tipAmountLabel.frame.origin.y, 100, 40)
        self.tipLabel.text = "Tip("+String(self.tipPercent * 100) + "%)"
        
        self.view.addSubview(self.tipLabel)
        
        
        
        self.totalAmountLabel = UILabel()
        self.totalAmountLabel.frame = CGRectMake(self.screenWidth - 100, self.tipAmountLabel.frame.origin.y + self.tipAmountLabel.frame.height, 100, 40)
        self.totalAmountLabel.text = "$0.00"
        
        self.totalAmountLabel.textAlignment = .Right
        self.view.addSubview(self.totalAmountLabel)
        
        self.totalLabel = UILabel()
        self.totalLabel.frame = CGRectMake(self.totalAmountLabel.frame.origin.x - 100, self.totalAmountLabel.frame.origin.y, 100, 40)
        self.totalLabel.text = "Total:"
        self.view.addSubview(self.totalLabel)
    }
    
    func sliderSetup(){
        self.tipPercentSlider = UISlider()
        self.tipPercentSlider.frame = CGRectMake(20, 300, self.screenWidth - 40, 50)
        self.tipPercentSlider.minimumValue = 0.05
        self.tipPercentSlider.maximumValue = 0.30
        self.tipPercentSlider.value = 0.15
        self.tipPercentSlider.addTarget(self, action: "sliderValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(self.tipPercentSlider)
        
    }
    
    func sliderValueChanged(sender: UISlider){
        print("haha")
        self.tipPercent = Double(self.tipPercentSlider.value)
        self.reloadAmount()
    }
    
    func pickerSetup(){
        
        self.pickerLabel = UILabel()
        self.pickerLabel.frame = CGRectMake(self.screenWidth / 2 - 100, self.tipPercentSlider.frame.origin.y + self.tipPercentSlider.frame.height, 200, 40)
        self.pickerLabel.text = "Number of Party"
        self.pickerLabel.textAlignment = .Center
        self.pickerLabel.font = UIFont.boldSystemFontOfSize(18)
        self.view.addSubview(self.pickerLabel)
        
        
        self.numberOfPartyPicker = UIPickerView()
        self.numberOfPartyPicker.frame = CGRectMake(self.screenWidth / 2 - 100, self.pickerLabel.frame.origin.y + self.pickerLabel.frame.height, 200, 100)
        self.numberOfPartyPicker.delegate = self
        self.numberOfPartyPicker.dataSource = self
        
        
        self.view.addSubview(self.numberOfPartyPicker)
    }
    
    func individualLabelSetup(){
        self.individualAmountLabel = UILabel()
        self.individualAmountLabel.frame = CGRectMake(self.screenWidth / 2 - 100, self.numberOfPartyPicker.frame.origin.y + self.numberOfPartyPicker.frame.height + 10, 100, 50)
        self.individualAmountLabel.text = "Each Pay"
        self.individualAmountLabel.font = UIFont.boldSystemFontOfSize(16)
        self.individualAmountLabel.textAlignment = .Center
        self.view.addSubview(self.individualAmountLabel)
        
        self.individualAmount = UILabel()
        self.individualAmount.frame = CGRectMake(self.screenWidth / 2 - 100, self.individualAmountLabel.frame.origin.y + self.individualAmountLabel.frame.height, 100, 50)
        self.individualAmount.text = "$0.00"
        self.individualAmount.textAlignment = .Center
        self.individualAmount.font = UIFont.boldSystemFontOfSize(14)
        self.view.addSubview(self.individualAmount)
        
        
        self.individualTipLabel = UILabel()
        self.individualTipLabel.frame = CGRectMake(self.screenWidth / 2, self.numberOfPartyPicker.frame.origin.y + self.numberOfPartyPicker.frame.height + 10, 100, 50)
        self.individualTipLabel.text = "Each Tip"
        self.individualTipLabel.font = UIFont.boldSystemFontOfSize(16)
        self.individualTipLabel.textAlignment = .Center
        self.view.addSubview(self.individualTipLabel)
        
        
        self.individualTip = UILabel()
        self.individualTip.frame = CGRectMake(self.screenWidth / 2, self.individualAmountLabel.frame.origin.y + self.individualAmountLabel.frame.height, 100, 50)
        self.individualTip.textAlignment = .Center
        self.individualTip.text = "$0.00"
        self.individualTip.font = UIFont.boldSystemFontOfSize(14)
        self.view.addSubview(self.individualTip)
        
    }
    
    /*
        Delegates
    */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.pickerDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var tip = self.currentNumber * round(self.tipPercent * 100)/100
        var total = self.currentNumber + tip
        
        
        var tipRound = Double(round(tip * 100)/100)
        tipRound/=Double(row+1)
        
        total/=Double(row+1)
        
        self.individualAmount.text = "$" + String(total.format(".2"))
        self.individualTip.text = "$" + String(tipRound.format(".2"))
        
    }
    
    
    /*
        Actions
    */
    
    func rightBarButtonItemOnClick(sender: UIBarButtonItem){
        
        if self.inputTextField.text?.characters.count == 1 && self.inputTextField.text?.characters.first == "$" {
            self.inputTextField.text = ""
            self.currentNumber = 0
        }
        
        
        if self.inputTextField.text != "" {
            
            
            if self.inputTextField.text?.characters.first != "$"{
                self.inputTextField.text = "$" + self.inputTextField.text!
            }
            
            
            if self.inputTextField.text?.characters.first == "$"{
                var index = self.inputTextField.text?.startIndex.advancedBy(1)
                var s = self.inputTextField.text?.substringFromIndex(index!)
                self.currentNumber = Double(s!)!
                
                
                self.inputTextField.text = "$" + String(self.currentNumber.format(".2"))
                print(self.inputTextField.text)
                
            }
            
            
            
            
    
        }else{
            self.currentNumber = 0
        }
    
    self.reloadAmount()
    self.inputTextField.resignFirstResponder()
    print(self.currentNumber)
    
        

    }
    
    func reloadAmount(){
        
        var tip = self.currentNumber * round(self.tipPercent * 100)/100
        var tipRound = Double(round(tip * 100)/100)
        
        self.tipAmountLabel.text = "$" + String(tipRound.format(".2"))
        
        var total = self.currentNumber + tip
        var totalRound = Double(round(total * 100)/100)
        
        self.totalAmountLabel.text = "$" + String(totalRound.format(".2"))
        
        self.tipLabel.text = "Tip(" + String(round(self.tipPercent * 100)) + "%)"
        
        
        self.pickerView(self.numberOfPartyPicker, didSelectRow: self.numberOfPartyPicker.selectedRowInComponent(0), inComponent: 0)
        
    
    }
    
    
    
}
