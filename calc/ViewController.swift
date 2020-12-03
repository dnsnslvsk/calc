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
    
    lazy var objectDataSourceArray = [
        PickerModel(mode: .mass, dataSourceArray: [
            Mass.kg.rawValue,
            Mass.t.rawValue,
            Mass.g.rawValue,
            Mass.N.rawValue
        ], parameterName: "Par X"),
        PickerModel(dataSourceArray: lengthArray)
    ]
    lazy var currentObjectDataSourceArray = objectDataSourceArray[0]

    
    let massArray = [
        Mass.kg.rawValue,
        Mass.t.rawValue,
        Mass.g.rawValue,
        Mass.N.rawValue
    ]
    
    let lengthArray = [
        Length.mm.rawValue,
        Length.cm.rawValue,
        Length.m.rawValue,
    ]

    let parameterNameArray = [
        "Par X",
        "Par Y"
    ]
    
        // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        picker.delegate = self
        picker.dataSource = self
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
    let picker = PickerFactory.makePicker()
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
        let name = massArray[0]
        button.setTitle(name, for: .normal)
        firstDimensionButton.addTarget(self, action: #selector(firstDimensionButtonAction(_ :)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    private func configureSecondDimensionButton(_ button: UIButton) {
        button.frame = CGRect(x: 120, y: 150, width: 100, height: 40)
        let name = lengthArray[0]
        button.setTitle(name, for: .normal)
        secondDimensionButton.addTarget(self, action: #selector(secondDimensionButtonAction(_ :)), for: .touchUpInside)
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
        picker.frame = CGRect(x: 0, y: 500, width: view.bounds.width, height: 100)
        view.addSubview(picker)
    }
    
    
    private func configureTable(_ table: UITableView) {
        table.frame = CGRect(x: 0, y: 350, width: view.bounds.width, height: 100)
        calculatorTable.register(Cell.self, forCellReuseIdentifier: "cell")
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
        currentObjectDataSourceArray = objectDataSourceArray[0]
        picker.isHidden = false
        configurePicker(picker)
        picker.reloadAllComponents()
    }
    
    @objc
    private func secondDimensionButtonAction(_ : UIButton) {
        currentObjectDataSourceArray = objectDataSourceArray[1]
        picker.isHidden = false
        configurePicker(picker)
        picker.reloadAllComponents()
    }
    
}

    
extension ViewController: UIPickerViewDataSource {
    
    // MARK: - UIPickerViewDelegate implementation
    
    func numberOfComponents(in picker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ picker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return currentObjectDataSourceArray.dataSourceArray.count
    }
}

extension ViewController: UIPickerViewDelegate {
    
    // MARK: - UIPickerViewDataSource implementation
    
    func pickerView(_ picker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currentObjectDataSourceArray.dataSourceArray[row]
    }
    
    func pickerView(_ picker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentObjectDataSourceArray.dataSourceArray == objectDataSourceArray[0].dataSourceArray {
            firstDimensionButton.setTitle(massArray[row], for: .normal)
        } else if currentObjectDataSourceArray.dataSourceArray == objectDataSourceArray[1].dataSourceArray {
            secondDimensionButton.setTitle(lengthArray[row], for: .normal)
        }
        picker.isHidden = true
    }
    
}

extension ViewController: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate implementation
    
}

extension ViewController: UITableViewDataSource{
    
    // MARK: - UITableViewDataSource implementation
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parameterNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! Cell
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
    
    func callPicker() {
        view.addSubview(picker)
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

extension ViewController {
    
    //MARK: - Lenght dimensions
    
    enum Mode: String {
        case mm = "mm"
        case cm = "cm"
        case m = "m"
    }
}
