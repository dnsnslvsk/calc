//
//  ViewController.swift
//  calc
//
//  Created by Nesiolovsky on 07.11.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//
//  

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    // MARK: - Constants
    
    let dataPickerMassArray = ["kg", "t", "g", "mkg"]
    let dataPickerLenghtArray = ["mm", "cm", "m"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(buttonDimension)
        buttonDimension.addTarget(self, action: #selector(buttonCallPicker (_ :)), for: .touchUpInside)
        view.addSubview(textFieldDimension)
        view.addSubview(textFieldDValue1)
        view.addSubview(textFieldDValue2)
        textFieldDimension.text = dataPickerLenghtArray[0]
        textFieldDimension.addTarget(self, action: #selector(textFieldCallPicker (_ :)), for: .allTouchEvents)
        view.addSubview(buttonCalculate)
        buttonCalculate.addTarget(self, action: #selector(buttonCalculating (_ :)), for: .touchUpInside)
        pickerMass.delegate = self
        pickerMass.dataSource = self
        pickerLengt.delegate = self
        pickerLengt.dataSource = self
    }
    
    // MARK: - Configure
    
    let label1 = LableFactory.makeLable(
        frame: CGRect(x: 10, y: 100, width: 100, height: 40),
        name: "parameter A")
    let label2 = LableFactory.makeLable(
        frame: CGRect(x: 10, y: 150, width: 100, height: 40),
        name: "parameter B")
    let textFieldDimension = TexfFieldFactory.makeTextField(
        frame: CGRect(x: 120, y: 150, width: 100, height: 40),
        name: "1")
    lazy var buttonDimension = ButtonFactory.makeButton(
        frame: CGRect(x: 120, y: 100, width: 100, height: 40),
        name: dataPickerMassArray[0])
    let textFieldDValue1 = TexfFieldFactory.makeTextField(
        frame: CGRect(x: 250, y: 100, width: 100, height: 40),
        name: "0")
    let textFieldDValue2 = TexfFieldFactory.makeTextField(
        frame: CGRect(x: 250, y: 150, width: 100, height: 40),
        name: "0")
    let buttonCalculate = ButtonFactory.makeButton(
        frame: CGRect(x: 150, y: 400, width: 100, height: 40),
        name: "Calculate")
    lazy var pickerMass = PickerFactory.makePicker(frame: CGRect(x: 0, y: 550, width: view.bounds.width, height: 100))
    lazy var pickerLengt = PickerFactory.makePicker(frame: CGRect(x: 0, y: 550, width: view.bounds.width, height: 100))
    
    // MARK: - Actions
    	
    @objc
    func buttonCalculating (_ : UIButton) {
        //guard textFieldDValue1.text != nil && textFieldDValue2.text != nil else {return}  it doesnt work lolwat
        guard let textTextFieldDValue1 = textFieldDValue1.text, let numberTextFieldDValue1 = Int(textTextFieldDValue1) else {return}
        guard let textTextFieldDValue2 = textFieldDValue2.text, let numberTextFieldDValue2 = Int(textTextFieldDValue2) else {return}
        let sumValues = numberTextFieldDValue1+numberTextFieldDValue2
        let sumResultAlert = UIAlertController(title: "The sum is", message: String(sumValues), preferredStyle: .alert)
        sumResultAlert.addAction(UIAlertAction(title: "Good", style: .default, handler: nil))
        sumResultAlert.addAction(UIAlertAction(title: "Not good", style: .default, handler: nil))
        present(sumResultAlert, animated: true, completion: nil)
    }
    
    @objc
    func buttonCallPicker (_ : UIButton) {
        pickerMass.isHidden = false
        textFieldDimension.isUserInteractionEnabled = false
        self.view.addSubview(pickerMass)
    }
    
    @objc
    func textFieldCallPicker (_ : UITextField) {
        pickerLengt.isHidden = false
        buttonDimension.isUserInteractionEnabled = false
        self.view.addSubview(pickerLengt)
    }

    // MARK: - UIPickerViewDelegate implementation
    
    func numberOfComponents(in picker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ picker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if picker == pickerMass {
            return dataPickerMassArray.count
        } else if picker == pickerLengt {
            return dataPickerLenghtArray.count
        }
        return 0
    }
    
    // MARK: - UIPickerViewDataSource implementation
    
    func pickerView(_ picker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if picker == pickerMass {
            return dataPickerMassArray[row]
        } else if picker == pickerLengt {
            return dataPickerLenghtArray[row]
        }
        return ""
    }
    
    func pickerView(_ picker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if picker == pickerMass {
            buttonDimension.setTitle(dataPickerMassArray[row], for: .normal)
        } else if picker == pickerLengt {
            textFieldDimension.text = dataPickerLenghtArray[row]
        }
        textFieldDimension.isUserInteractionEnabled = true
        buttonDimension.isUserInteractionEnabled = true
        picker.isHidden = true
    }
}
