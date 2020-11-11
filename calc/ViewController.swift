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
    
    let dataPickerMassArray = ["kg", "t", "g", "mkg"]
    let dataPickerLenghtArray = ["mm", "cm", "m"]
    let textFieldDValue1 = TexfFieldFactory.makeTextField(frame: CGRect(x: 250, y: 100, width: 100, height: 40), name: "0")
    let textFieldDValue2 = TexfFieldFactory.makeTextField(frame: CGRect(x: 250, y: 150, width: 100, height: 40), name: "0")
    let textFieldDimension = TexfFieldFactory.makeTextField(frame: CGRect(x: 120, y: 150, width: 100, height: 40), name: "1")
    lazy var buttonDimension = ButtonFactory.makeButton(frame: CGRect(x: 120, y: 100, width: 100, height: 40), name: dataPickerMassArray[0]) //"name:dataPickerMassArray[0]" with help of "lazy var" ok? OR NOT
    let buttonCalculate = ButtonFactory.makeButton(frame: CGRect(x: 150, y: 400, width: 100, height: 40), name: "Calculate")
    lazy var pickerMass = PickerFactory.makePicker(frame: CGRect(x: 0, y: 550, width: view.bounds.width, height: 100)) //"view.bounds.width" with help of "lazy var" ok? OR NOT
    lazy var pickerLengt = PickerFactory.makePicker(frame: CGRect(x: 0, y: 550, width: view.bounds.width, height: 100))
    
    func numberOfComponents(in pickerMass: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerMass: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isButtonCallPickerClicked == true {
            return dataPickerMassArray.count
        }
        if isTextFieldDimensionClicked == true {
            return dataPickerLenghtArray.count
        }
        return 0
    }
    
    func pickerView(_ pickerMass: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if isButtonCallPickerClicked == true {
            return dataPickerMassArray[row]
        }
        if isTextFieldDimensionClicked == true {
            return dataPickerLenghtArray[row]
        }
        return ""
    }
    
    func pickerView(_ pickerMass: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isButtonCallPickerClicked == true {
            buttonDimension.setTitle(dataPickerMassArray[row], for: .normal)
            isButtonCallPickerClicked = false
            pickerMass.isHidden = true
            textFieldDimension.isUserInteractionEnabled = true
        }
        if isTextFieldDimensionClicked == true {
            textFieldDimension.text = dataPickerLenghtArray[row]
            isTextFieldDimensionClicked = false
            pickerLengt.isHidden = true
            buttonDimension.isUserInteractionEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textFieldDValue1)
        view.addSubview(textFieldDValue2)
        textFieldDimension.text = dataPickerLenghtArray[0]
        view.addSubview(textFieldDimension)
        textFieldDimension.addTarget(self, action: #selector(textFieldCallPicker (_ :)), for: .allTouchEvents)
        view.addSubview(LableFactory.makeLable(frame: CGRect(x: 10, y: 100, width: 100, height: 40), name: "parameter A"))
        view.addSubview(LableFactory.makeLable(frame: CGRect(x: 10, y: 150, width: 100, height: 40), name: "parameter B"))
        view.addSubview(buttonDimension)
        buttonDimension.addTarget(self, action: #selector(buttonCallPicker (_ :)), for: .touchUpInside)
        view.addSubview(buttonCalculate)
        buttonCalculate.addTarget(self, action: #selector(buttonCalculating (_ :)), for: .touchUpInside)
        pickerMass.delegate = self
        pickerMass.dataSource = self
        pickerLengt.delegate = self
        pickerLengt.dataSource = self
    }
    
    @objc func buttonCalculating (_ : UIButton) {
        //guard textFieldDValue1.text != nil && textFieldDValue2.text != nil else {return}  it doesnt work lolwat
        guard let textTextFieldDValue1 = textFieldDValue1.text, let numberTextFieldDValue1 = Int(textTextFieldDValue1) else {return}
        guard let textTextFieldDValue2 = textFieldDValue2.text, let numberTextFieldDValue2 = Int(textTextFieldDValue2) else {return}
        let sum = numberTextFieldDValue1+numberTextFieldDValue2
        let alert = UIAlertController(title: "The sum is", message: String(sum), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Good", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Not good", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    var isButtonCallPickerClicked = false
    @objc func buttonCallPicker (_ : UIButton) {
        isButtonCallPickerClicked = true
        pickerMass.isHidden = false
        textFieldDimension.isUserInteractionEnabled = false
        self.view.addSubview(pickerMass) //blya pochemy self
    }
    
    var isTextFieldDimensionClicked = false
    @objc func textFieldCallPicker (_ : UITextField) {
        isTextFieldDimensionClicked = true
        pickerLengt.isHidden = false
        buttonDimension.isUserInteractionEnabled = false
        self.view.addSubview(pickerLengt) //blya pochemy self nago guglit' ponimat'
    }
}
