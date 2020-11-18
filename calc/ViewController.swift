//
//  ViewController.swift
//  calc
//
//  Created by Nesiolovsky on 07.11.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//
//  

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Internal methods
    
    let massArray = ["kg", "t", "g", "mkg"]
    let lenghtArray = ["mm", "cm", "m"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(xLabel)
        confugurexLabel(xLabel)
        view.addSubview(yLabel)
        confugureyLabel(yLabel)
        view.addSubview(dimensionButton)
        confugureDimensionButton(dimensionButton)
        dimensionButton.addTarget(self, action: #selector(callPickerButton (_ :)), for: .touchUpInside)
        view.addSubview(dimensionTextField)
        confugureDimensionTextField(dimensionTextField)
        dimensionTextField.addTarget(self, action: #selector(callPickerTextField (_ :)), for: .allTouchEvents)
        view.addSubview(xValueTextField)
        confugurexValueTextField(xValueTextField)
        view.addSubview(yValueTextField)
        confugureyValueTextField(yValueTextField)
        view.addSubview(calculateButton)
        confugureCalculateButton(calculateButton)
        calculateButton.addTarget(self, action: #selector(calculateButtonAction (_ :)), for: .touchUpInside)
        massPicker.delegate = self
        massPicker.dataSource = self
        lenghtPicker.delegate = self
        lenghtPicker.dataSource = self
    }
    
    // MARK: - Public methods
    
    let xLabel = LableFactory.makeLabel()
    let yLabel = LableFactory.makeLabel()
    let dimensionButton = ButtonFactory.makeButton()
    let dimensionTextField = TexfFieldFactory.makeTextField()
    let xValueTextField = TexfFieldFactory.makeTextField()
    let yValueTextField = TexfFieldFactory.makeTextField()
    let calculateButton = ButtonFactory.makeButton()
    let massPicker = PickerFactory.makePicker()
    let lenghtPicker = PickerFactory.makePicker()
    
    private func sumResultAlert(_ sum: String) {
        let alert = UIAlertController(title: "The sum is", message: sum, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Good", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Not good", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Configure
    
    private func confugurexLabel(_ label: UILabel) {
        label.text = "Parameter X"
        label.frame = CGRect(x: 10, y: 100, width: 100, height: 40)
        label.textAlignment = .center
        label.backgroundColor = .systemGray
    }
    
    private func confugureyLabel(_ label: UILabel) {
        label.text = "Parameter Y"
        label.frame = CGRect(x: 10, y: 150, width: 100, height: 40)
        label.textAlignment = .center
        label.backgroundColor = .systemGray
    }
    
    private func confugureDimensionButton(_ button: UIButton) {
        button.frame = CGRect(x: 120, y: 100, width: 100, height: 40)
        let name = massArray[0]
        button.backgroundColor = UIColor.black
        button.setTitle(name, for: .normal)
    }
    
    private func confugureDimensionTextField(_ textField: UITextField) {
        textField.frame = CGRect(x: 120, y: 150, width: 100, height: 40)
        dimensionTextField.text = lenghtArray[0]
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.numbersAndPunctuation
        textField.returnKeyType = UIReturnKeyType.continue
        textField.clearButtonMode = UITextField.ViewMode.always
        textField.textAlignment = .center
    }
    
    private func confugurexValueTextField(_ textField: UITextField) {
        textField.frame = CGRect(x: 250, y: 100, width: 100, height: 40)
        textField.placeholder = "0"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.numbersAndPunctuation
        textField.returnKeyType = UIReturnKeyType.continue
        textField.clearButtonMode = UITextField.ViewMode.always
        textField.textAlignment = .center
    }
    
    private func confugureyValueTextField(_ textField: UITextField) {
        textField.frame = CGRect(x: 250, y: 150, width: 100, height: 40)
        textField.placeholder = "0"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.numbersAndPunctuation
        textField.returnKeyType = UIReturnKeyType.continue
        textField.clearButtonMode = UITextField.ViewMode.always
        textField.textAlignment = .center
    }
    
    private func confugureCalculateButton(_ button: UIButton) {
        button.frame = CGRect(x: 150, y: 400, width: 100, height: 40)
        let name = "Calculate"
        button.backgroundColor = UIColor.black
        button.setTitle(name, for: .normal)
    }
    
    private func confugurePicker(_ picker: UIPickerView) {
        picker.frame = CGRect(x: 0, y: 550, width: view.bounds.width, height: 100)
    }
    
    
    // MARK: - Actions
    	
    @objc
    private func calculateButtonAction(_ : UIButton) {
        //guard textFieldDValue1.text != nil && textFieldDValue2.text != nil else {return}  it doesnt work lolwat
        guard let textxValueTextField = xValueTextField.text, let numberxValueTextField = Int(textxValueTextField) else {return}
        guard let textyValueTextField = yValueTextField.text, let numberyValueTextField = Int(textyValueTextField) else {return}
        let sumValues = String(numberxValueTextField+numberyValueTextField)
        sumResultAlert(sumValues)
    }
    
    @objc
    private func callPickerButton(_ : UIButton) {
        massPicker.isHidden = false
        dimensionTextField.isEnabled = false
        view.addSubview(massPicker)
        confugurePicker(massPicker)
    }
    
    @objc
    private func callPickerTextField(_ : UITextField) {
        lenghtPicker.isHidden = false
        dimensionButton.isEnabled = false
        view.addSubview(lenghtPicker)
        confugurePicker(lenghtPicker)
    }
}
    
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - UIPickerViewDelegate implementation
    
    func numberOfComponents(in picker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ picker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if picker === massPicker {
            return massArray.count
        } else if picker === lenghtPicker {
            return lenghtArray.count
        } else {return 0}
        
    }
    
    // MARK: - UIPickerViewDataSource implementation
    
    func pickerView(_ picker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if picker === massPicker {
            return massArray[row]
        } else if picker === lenghtPicker {
            return lenghtArray[row]
        } else {return ""}
    }
    
    func pickerView(_ picker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if picker === massPicker {
            dimensionButton.setTitle(massArray[row], for: .normal)
        } else if picker === lenghtPicker {
            dimensionTextField.text = lenghtArray[row]
        }
        dimensionTextField.isEnabled = true
        dimensionButton.isEnabled = true
        picker.isHidden = true
    }
}


