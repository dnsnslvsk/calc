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
        confugureFirstLabel(firstLabel)
        confugureSecondLabel(secondLabel)
        confugureDimensionButton(dimensionButton)
        dimensionButton.addTarget(self, action: #selector(callPickerButton (_ :)), for: .touchUpInside)
        confugureDimensionTextField(dimensionTextField)
        dimensionTextField.addTarget(self, action: #selector(callPickerTextField (_ :)), for: .allTouchEvents)
        confugureFirstValueTextField(firstValueTextField)
        confugureSecondValueTextField(secondValueTextField)
        confugureCalculateButton(calculateButton)
        calculateButton.addTarget(self, action: #selector(calculateButtonAction (_ :)), for: .touchUpInside)
        massPicker.delegate = self
        massPicker.dataSource = self
        lenghtPicker.delegate = self
        lenghtPicker.dataSource = self
    }
    
    // MARK: - Public methods
    
    let firstLabel = LabelFactory.makeLabel()
    let secondLabel = LabelFactory.makeLabel()
    let dimensionButton = ButtonFactory.makeButton()
    let dimensionTextField = TexfFieldFactory.makeTextField()
    let firstValueTextField = TexfFieldFactory.makeTextField()
    let secondValueTextField = TexfFieldFactory.makeTextField()
    let calculateButton = ButtonFactory.makeButton()
    let massPicker = PickerFactory.makePicker()
    let lenghtPicker = PickerFactory.makePicker()
    
    private func callSumResultAlert(_ sum: String) {
        let alert = UIAlertController(title: "The sum is", message: sum, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Good", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Not good", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Configure
    
    private func confugureFirstLabel(_ label: UILabel) {
        label.text = "Parameter X"
        label.frame = CGRect(x: 10, y: 100, width: 100, height: 40)
        view.addSubview(label)
    }
    
    private func confugureSecondLabel(_ label: UILabel) {
        label.text = "Parameter Y"
        label.frame = CGRect(x: 10, y: 150, width: 100, height: 40)
        view.addSubview(label)
    }
    
    private func confugureDimensionButton(_ button: UIButton) {
        button.frame = CGRect(x: 120, y: 100, width: 100, height: 40)
        let name = massArray[0]
        button.setTitle(name, for: .normal)
        view.addSubview(button)
    }
    
    private func confugureDimensionTextField(_ textField: UITextField) {
        textField.frame = CGRect(x: 120, y: 150, width: 100, height: 40)
        dimensionTextField.text = lenghtArray[0]
        view.addSubview(textField)
    }
    
    private func confugureFirstValueTextField(_ textField: UITextField) {
        textField.frame = CGRect(x: 250, y: 100, width: 100, height: 40)
        textField.placeholder = "0"
        view.addSubview(textField)

    }
    
    private func confugureSecondValueTextField(_ textField: UITextField) {
        textField.frame = CGRect(x: 250, y: 150, width: 100, height: 40)
        textField.placeholder = "0"
        view.addSubview(textField)
    }
    
    private func confugureCalculateButton(_ button: UIButton) {
        button.frame = CGRect(x: 150, y: 400, width: 100, height: 40)
        let name = "Calculate"
        button.setTitle(name, for: .normal)
        view.addSubview(button)
    }
    
    private func confugurePicker(_ picker: UIPickerView) {
        picker.frame = CGRect(x: 0, y: 550, width: view.bounds.width, height: 100)
        view.addSubview(picker)
    }
    
    // MARK: - Actions
    	
    @objc
    private func calculateButtonAction(_ : UIButton) {
        guard let textFirstValueTextField = firstValueTextField.text, let numberFirstValueTextField = Int(textFirstValueTextField) else {return}
        guard let textSecondValueTextField = secondValueTextField.text, let numberSecondValueTextField = Int(textSecondValueTextField) else {return}
        let sumValues = String(numberFirstValueTextField+numberSecondValueTextField)
        callSumResultAlert(sumValues)
    }
    
    @objc
    private func callPickerButton(_ : UIButton) {
        massPicker.isHidden = false
        dimensionTextField.isEnabled = false
        confugurePicker(massPicker)
    }
    
    @objc
    private func callPickerTextField(_ : UITextField) {
        lenghtPicker.isHidden = false
        dimensionButton.isEnabled = false
        confugurePicker(lenghtPicker)
    }
}
    
extension ViewController: UIPickerViewDelegate {
    
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
}

extension ViewController: UIPickerViewDataSource {
    
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
