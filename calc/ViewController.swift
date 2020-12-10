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
    
    lazy var models = [
        PickerModel(
            parameterName: "Сила, F",
            currentButtonName: Mass.kg,
            mode: .mass,
            dataSourceArray: [
             Mass.kg,
             Mass.t,
             Mass.g,
             Mass.N
            ],
            inputTextFieldValue: ""),
        PickerModel(
            parameterName: "Длина, L",
            currentButtonName: Length.mm,
            mode: .length,
            dataSourceArray: [
             Length.mm,
             Length.cm,
             Length.m,
            ],
           inputTextFieldValue: "")
    ]
    
    lazy var currentModel = models[0]
        
        // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        picker.delegate = self
        picker.dataSource = self
        inputTableView.delegate = self
        inputTableView.dataSource = self
        

    }
    
    // MARK: - Public methods
    
    let calculateButton = ButtonFactory.makeButton()
    let picker = PickerFactory.makePicker()
    let inputTableView = TableFactory.makeTable()
    
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
        configureCalculateButton(calculateButton)
        configureTable(inputTableView)
    }

    private func configureCalculateButton(_ button: UIButton) {
        button.frame = CGRect(x: 150, y: 600, width: 100, height: 40)
        let name = "Calculate"
        button.setTitle(name, for: .normal)
        calculateButton.addTarget(self, action: #selector(calculateButtonAction(_ :)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    private func configurePicker(_ picker: UIPickerView) {
        picker.frame = CGRect(x: 0, y: 550, width: view.bounds.width, height: 100)
    }

    private func configureTable(_ table: UITableView) {
        table.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 500)
        table.register(Cell.self, forCellReuseIdentifier: "cell")
        view.addSubview(table)
    }
    
    
    
    // MARK: - Actions
    	
    @objc
    private func calculateButtonAction(_: UIButton) {
        let firstValue: String = models[0].inputTextFieldValue
        let secondValue: String  = models[1].inputTextFieldValue
        guard let numberFirstValueTextField = Float(firstValue) else { return }
        guard let numberSecondValueTextField = Float(secondValue) else { return }
        let sumValues = String(numberFirstValueTextField+numberSecondValueTextField)
        callSumResultAlert(sumValues)
    }
}
    
extension ViewController: UIPickerViewDataSource {
    
    // MARK: - UIPickerViewDelegate implementation
    
    func numberOfComponents(in picker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ picker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return currentModel.dataSourceArray.count
    }
}

extension ViewController: UIPickerViewDelegate {
    
    // MARK: - UIPickerViewDataSource implementation
    
    func pickerView(_ picker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currentModel.dataSourceArray[row].description
    }
    
    func pickerView(_ picker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        
        if currentModel.mode == models[0].mode {
            models[0].currentButtonName = currentModel.dataSourceArray[row]
        } else if currentModel.mode == models[1].mode {
            models[1].currentButtonName = currentModel.dataSourceArray[row]
        }
        inputTableView.reloadData()
        picker.isHidden = true
    }
    
}

extension ViewController: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate implementation
    
}

extension ViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource implementation
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! Cell
        cell.delegate = self
        let model = models[indexPath.row]
        cell.setNameParameterLabel(model.parameterName)
        cell.setNameDimensionButton(model.currentButtonName.description)
        cell.mode = model.mode
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> Int {
        return Constant.tableViewEstimatedRowHeight
     }
}

extension ViewController: ICellDelegate {
    
    // MARK: - ISetPicker implementation
    
    func didSelectCell(_ cell: Cell) {
        guard
        let newCurrentMode = cell.mode,
        let newCurrentModel = models.first(where: { $0.mode == newCurrentMode }) else { return }
        currentModel = newCurrentModel
        
        picker.reloadAllComponents()
        picker.isHidden = false
        view.addSubview(picker)
    }
    
    func didInputTextField(_ cell: Cell) {
        switch cell.mode {
        case .mass:
            models[0].inputTextFieldValue = cell.inputTextFieldValue
        case .length:
            models[1].inputTextFieldValue = cell.inputTextFieldValue
        default:
            return
        }
    }
}






