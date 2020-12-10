//
//  ViewController.swift
//  calc
//
//  Created by Nesiolovsky on 07.11.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//
//  

import UIKit
import os

final class ViewController: UIViewController {
    
    // MARK: - Internal methods
    
    lazy var models = [
        PickerModel(
            parameterName: "Больший диаметр, D1",
            currentButtonName: Diameter.mm,
            mode: .diameter,
            dataSourceArray: [
             Diameter.mm,
             Diameter.inch,
             Diameter.m,
            ],
            inputTextFieldValue: ""),
        PickerModel(
            parameterName: "Меньший диаметер, D2",
            currentButtonName: Diameter.mm,
            mode: .diameter,
            dataSourceArray: [
             Diameter.mm,
             Diameter.inch,
             Diameter.m,
            ],
           inputTextFieldValue: ""),
        PickerModel(
            parameterName: "Давление, P",
            currentButtonName: StressAndPressure.MPa,
            mode: .stressAndPressure,
            dataSourceArray: [
             StressAndPressure.MPa,
             StressAndPressure.Pa,
             StressAndPressure.psi,
             StressAndPressure.bar
            ],
           inputTextFieldValue: ""
        ),
        PickerModel(
            parameterName: "Диаметр срезного элемента, d",
            currentButtonName: Diameter.mm,
            mode: .diameter,
            dataSourceArray: [
             Diameter.mm,
             Diameter.inch,
             Diameter.m,
            ],
           inputTextFieldValue: ""),
        PickerModel(
            parameterName: "Доп. напряжение на срез, [σ]τ",
            currentButtonName: StressAndPressure.MPa,
            mode: .stressAndPressure,
            dataSourceArray: [
             StressAndPressure.MPa,
             StressAndPressure.Pa,
             StressAndPressure.psi,
             StressAndPressure.bar
            ],
           inputTextFieldValue: "")
    ]
    
    lazy var currentModel = models[0]
    
    var calculateResults: [String] = []

        
        // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: - Make Factory
        self.navigationItem.title = "Количество болтов"
        let doneItem = UIBarButtonItem(title: "История", style: .plain, target: self, action:  #selector(showHistory(_:)))
        self.navigationItem.setRightBarButton(doneItem, animated: true)

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
        configurePicker(picker)
    }

    private func configureCalculateButton(_ button: UIButton) {
        button.frame = CGRect(x: 150, y: 600, width: 100, height: 40)
        let name = "Calculate"
        button.setTitle(name, for: .normal)
        calculateButton.addTarget(self, action: #selector(calculateButtonAction(_ :)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    private func configurePicker(_ picker: UIPickerView) {
        picker.frame = CGRect(x: 0, y: 450, width: view.bounds.width, height: 100)
    }

    private func configureTable(_ table: UITableView) {
        table.frame = CGRect(x: 0, y: 44, width: view.bounds.width, height: 400)
        table.register(Cell.self, forCellReuseIdentifier: "cell")
        view.addSubview(table)
    }
    
    
    
    // MARK: - Actions
    	
    @objc
    private func calculateButtonAction(_: UIButton) {
        print(models)
        let firstValue: String = models[0].inputTextFieldValue
        let secondValue: String  = models[1].inputTextFieldValue
        let thirdValue: String  = models[2].inputTextFieldValue
        let fourthValue: String  = models[3].inputTextFieldValue
        let fifthValue: String  = models[4].inputTextFieldValue
        
        guard let D1 = Float(firstValue),
        let D2 = Float(secondValue),
        let P = Float(thirdValue),
        let d = Float(fourthValue),
        let στ = Float(fifthValue) else {
            let alert = UIAlertController(title: "Ti pidor", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "DA", style: .default, handler: { (_) in
                
            }))
            present(alert, animated: true)
            return }
        
        let calcCore = BoltsContCalcCore(D1: D1, D2: D2, P: P, d: d, στ: στ)
        
        let result = calcCore.getFormattedResult()

        calculateResults.append(result)
        
        callSumResultAlert(result)
    }

    @objc
    private func showHistory(_: UIButton) {
        let vc = HistoryTableViewController()
        vc.models = calculateResults
        self.navigationController?.pushViewController(vc, animated: true)
        
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
        guard let index = models.firstIndex(of: currentModel) else { return }
        models[index].currentButtonName = currentModel.dataSourceArray[row]
        os_log("kadyrov")
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
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> Int {
        return Constant.tableViewEstimatedRowHeight
     }
}

extension ViewController: ICellDelegate {
    
    // MARK: - ISetPicker implementation
    
    func didSelectCell(_ cell: Cell) {
        guard let model = cell.model else { return }
        currentModel = model
        picker.reloadAllComponents()
        picker.isHidden = false
        view.addSubview(picker)
    }
    
    func didInputTextField(_ cell: Cell) {
        guard let model = cell.model else { return }
        currentModel = model
        guard let index = models.firstIndex(of: currentModel) else { return }
        models[index].inputTextFieldValue = cell.inputTextFieldValue
    }
}






