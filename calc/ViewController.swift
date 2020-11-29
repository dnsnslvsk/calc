//
//  ViewController.swift
//  calc
//
//  Created by Nesiolovsky on 07.11.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//
//  

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - Internal methods
    
    let massArray = [
        Mass.kg,
        Mass.t,
        Mass.g,
        Mass.N
    ]
    
    let lengthArray = [
        Length.mm,
        Length.cm,
        Length.m,
    ]

    let parameterNameArray = [
        "Par X",
        "Par Y"
    ]
    
        // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        massPicker.delegate = self
        massPicker.dataSource = self
        lengthPicker.delegate = self
        lengthPicker.dataSource = self
        calculatorTable.delegate = self
        calculatorTable.dataSource = self
    }
    
    // MARK: - Public methods
    
    let firstDimensionButton = ButtonFactory.makeButton()
    let secondDimensionButton = ButtonFactory.makeButton()
    let dimensionTextField = TexfFieldFactory.makeTextField()
    let firstValueTextField = TexfFieldFactory.makeTextField()
    let secondValueTextField = TexfFieldFactory.makeTextField()
    let calculateButton = ButtonFactory.makeButton()
    let massPicker = PickerFactory.makePicker()
    let lengthPicker = PickerFactory.makePicker()
    let calculatorTable = TableFactory.makeTable()
    
    private func callSumResultAlert(_ sum: String) {
        let alert = UIAlertController(title: "The sum is", message: sum, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Good", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Not good", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Internal methods
    
    enum Constant {
        static let tableViewEstimatedRowHeight = 50
    }
    
    // MARK: - Configure
    
    func configure() {
        configureFirstDimensionButton(firstDimensionButton)
        configureSecondDimensionButton(secondDimensionButton)
        configureFirstValueTextField(firstValueTextField)
        configureSecondValueTextField(secondValueTextField)
        configureCalculateButton(calculateButton)
        configureTable(calculatorTable)
    }

    private func configureFirstDimensionButton(_ button: UIButton) {
        button.frame = CGRect(x: 120, y: 100, width: 100, height: 40)
        let name = massArray[0].rawValue
        button.setTitle(name, for: .normal)
        firstDimensionButton.addTarget(self, action: #selector(firstDimensionButtonAction(_ :)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    private func configureSecondDimensionButton(_ button: UIButton) {
        button.frame = CGRect(x: 120, y: 100, width: 100, height: 40)
        let name = lengthArray[0].rawValue
        button.setTitle(name, for: .normal)
        firstDimensionButton.addTarget(self, action: #selector(secondDimensionButtonAction(_ :)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    private func configureFirstValueTextField(_ textField: UITextField) {
        textField.frame = CGRect(x: 250, y: 100, width: 100, height: 40)
        textField.placeholder = "0"
        view.addSubview(textField)
    }
    
    private func configureSecondValueTextField(_ textField: UITextField) {
        textField.frame = CGRect(x: 250, y: 150, width: 100, height: 40)
        textField.placeholder = "0"
        view.addSubview(textField)
    }
 
    private func configureCalculateButton(_ button: UIButton) {
        button.frame = CGRect(x: 150, y: 300, width: 100, height: 40)
        let name = "Calculate"
        button.setTitle(name, for: .normal)
        calculateButton.addTarget(self, action: #selector(calculateButtonAction(_ :)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    private func configurePicker(_ picker: UIPickerView) {
        //picker.frame = CGRect(x: 0, y: 350, width: view.bounds.width, height: 100)
        view.addSubview(picker)
    }
    
    
    private func configureTable(_ table: UITableView) {
        table.frame = CGRect(x: 0, y: 350, width: view.bounds.width, height: 150)
        calculatorTable.register(CellFactory.self, forCellReuseIdentifier: "cell")
        view.addSubview(table)
    }
    
    
    
    // MARK: - Actions
    	
    @objc
    private func calculateButtonAction(_ : UIButton) {
        guard
            let textFirstValueTextField = firstValueTextField.text,
            let numberFirstValueTextField = Int(textFirstValueTextField) else { return }
        guard
            let textSecondValueTextField = secondValueTextField.text,
            let numberSecondValueTextField = Int(textSecondValueTextField) else { return }
        let sumValues = String(numberFirstValueTextField+numberSecondValueTextField)
        callSumResultAlert(sumValues)
    }
    
    @objc
    private func firstDimensionButtonAction(_ : UIButton) {
        massPicker.isHidden = false
        secondDimensionButton.isEnabled = false
        configurePicker(massPicker)
    }
    
    @objc
    private func secondDimensionButtonAction(_ : UIButton) {
        lengthPicker.isHidden = false
        firstDimensionButton.isEnabled = false
        configurePicker(lengthPicker)
    }
    
}
    
extension ViewController: UIPickerViewDataSource {
    
    // MARK: - UIPickerViewDelegate implementation
    
    func numberOfComponents(in picker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ picker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if picker === massPicker {
            return massArray.count
        } else if picker === lengthPicker {
            return lengthArray.count
        } else { return 0 }
    }
}

extension ViewController: UIPickerViewDelegate {
    
    // MARK: - UIPickerViewDataSource implementation
    
    func pickerView(_ picker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if picker === massPicker {
            return massArray[row].rawValue
        } else if picker === lengthPicker {
            return lengthArray[row].rawValue
        } else { return "" }
    }
    
    func pickerView(_ picker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if picker === massPicker {
            firstDimensionButton.setTitle(massArray[row].rawValue, for: .normal)
        } else if picker === lengthPicker {
            secondDimensionButton.setTitle(lengthArray[row].rawValue, for: .normal)
        }
        firstDimensionButton.isEnabled = true
        secondDimensionButton.isEnabled = true
        picker.isHidden = true
    }
}

extension ViewController: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate implementation
    
}

extension ViewController: UITableViewDataSource{
    
    // MARK: - UITableViewDataSource implementation
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! CellFactory
        cell.delegate = self
        cell.setNameParameterLabel(parameterNameArray[indexPath.row])
        cell.setNameDimensionButton()
        return cell
    }
    
    func tableView(_ tableView: UITableView,
             heightForRowAt indexPath: IndexPath) -> Int {
        return Constant.tableViewEstimatedRowHeight
     }
    
}



extension ViewController: ISetPicker{
    
    // MARK: - ISetPicker implementation
    
    func callPicker() -> UIPickerView {
        view.addSubview(massPicker)
        return massPicker
    }
    
}




extension ViewController {
    
    //MARK: - Mass dimensions
    
    enum Mass: String {
        case kg = "kg"
        case t = "t"
        case g = "g"
        case N = "N"
    }
}

extension ViewController {
    
    //MARK: - Lenght dimensions
    
    enum Length: String {
        case mm = "mm"
        case cm = "cm"
        case m = "m"
    }
}
