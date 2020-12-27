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
	
	// MARK: - Internal properties
	
	var inputModels: [CellModel] = []
	var outputModels: [CellModel] = []
	lazy var currentModel = inputModels[0]
	var calculateResults: [HistoryCellModel] = []
	var currentHistoryModel = HistoryCellModel(formattedResult: "", inputValues: [], outputValues: [])
	var currentRow = 0
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let boltsCountDataSource = BoltsCountDataSource()
		inputModels = boltsCountDataSource.inputModels
		outputModels = boltsCountDataSource.outputModels
		
		// TODO: - Make Factory
		self.navigationItem.title = "Количество болтов"
		let doneItem = UIBarButtonItem(title: "История", style: .plain, target: self, action:  #selector(showHistory(_:)))
		let menuItem = UIBarButtonItem(title: "Расчеты", style: .plain, target: self, action: .none)
		self.navigationItem.setRightBarButton(doneItem, animated: true)
		self.navigationItem.setLeftBarButton(menuItem, animated: true)
		
		configure()
		picker.delegate = self
		picker.dataSource = self
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	// MARK: - Public methods
	
	let picker = PickerFactory.makePicker()
	let tableView = TableFactory.makeTable()
	lazy var customView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
	
	// MARK: - Internal methods
	
	enum Constant {
		static let tableViewEstimatedRowHeight = 50
	}
	
	private func didCalculate() {
		let firstValue: String = inputModels[0].textFieldValue
		let secondValue: String  = inputModels[1].textFieldValue
		let thirdValue: String  = inputModels[2].textFieldValue
		let fourthValue: String  = inputModels[3].textFieldValue
		let fifthValue: String  = inputModels[4].textFieldValue
		guard
			let D1 = Float(firstValue),
			let D2 = Float(secondValue),
			let P = Float(thirdValue),
			let d = Float(fourthValue),
			let στ = Float(fifthValue)
			else { return }
		let calcCore = BoltsCountCalculationCore(D1: D1, D2: D2, P: P, d: d, στ: στ)
		let result = calcCore.getFormattedResult()
		for item in 0...outputModels.count-1 {
			outputModels[item].textFieldValue = result[item]
		}
		tableView.reloadSections(IndexSet(integer: 1), with: .fade)
		calculateResults.append(calcCore.getResultForHistory())
	}
	
	// MARK: - Configure
	
	func configure() {
		configureCustomView(customView)
		configureTable(tableView)
		configurePicker(picker)
	}
	
	private func configureCustomView(_ view: UIView) {
		customView.backgroundColor = .black
		customView.alpha = 0.9
	}
	
	private func configurePicker(_ picker: UIPickerView) {
		picker.frame = CGRect(x: 0, y: view.bounds.height/4, width: view.bounds.width, height: 150)
	}
	
	private func configureTable(_ table: UITableView) {
		table.frame = CGRect(x: 0, y: 44, width: view.bounds.width, height: 550)
		table.register(Cell.self, forCellReuseIdentifier: "cell")
		view.addSubview(table)
	}
	
	
	
	// MARK: - Actions
	
	@objc
	private func showHistory(_: UIButton) {
		let vc = HistoryTableViewController()
		vc.delegate = self
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
		if currentModel.sectionNumber == 0 {
			guard	let index = inputModels.firstIndex(of: currentModel) else { return }
			inputModels[index].currentButtonName = currentModel.dataSourceArray[row]
		} else if currentModel.sectionNumber == 1 {
			guard	let index = outputModels.firstIndex(of: currentModel) else { return }
			outputModels[index].currentButtonName = currentModel.dataSourceArray[row]
		}
		os_log("kadyrov")
		tableView.reloadData()
		picker.isHidden = true
		customView.isHidden = true
		currentRow = 0
	}
}

extension ViewController: UITableViewDelegate {
	
	// MARK: - UITableViewDelegate implementation
	
}

extension ViewController: UITableViewDataSource {
	
	// MARK: - UITableViewDataSource implementation
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return inputModels.count
		case 1:
			return outputModels.count
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! Cell
		cell.delegate = self
		switch indexPath.section {
		case 0:
			var model = inputModels[indexPath.row]
			cell.setNameParameterLabel(model.parameterName)
			cell.setNameDimensionButton(model.currentButtonName.description)
			cell.setValue(model.textFieldValue)
			model.sectionNumber = 0
			cell.model = model
			return cell
		case 1:
			var model = outputModels[indexPath.row]
			cell.setNameParameterLabel(model.parameterName)
			cell.setNameDimensionButton(model.currentButtonName.description)
			cell.setValue(model.textFieldValue)
			model.sectionNumber = 1
			cell.model = model
			return cell
		default:
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> Int {
		return Constant.tableViewEstimatedRowHeight
	}
}

extension ViewController: ICellDelegate {
	
	// MARK: - ICellDelegate implementation
	
	func didSelectCell(_ cell: Cell) {
		guard let model = cell.model else { return }
		currentModel = model
		picker.reloadAllComponents()
		picker.isHidden = false
		self.view.addSubview(customView)
		customView.isHidden = false
		
		for i in 0...currentModel.dataSourceArray.count-1 {
			if currentModel.currentButtonName.description == currentModel.dataSourceArray[i].description {
				picker.selectRow(currentRow, inComponent: 0, animated: false)
				break
			} else { currentRow += 1 }
		}
		
		view.addSubview(picker)
	}
	func didInputTextField(_ cell: Cell) {
		guard let model = cell.model else { return }
		currentModel = model
		guard let index = inputModels.firstIndex(of: currentModel) else { return }
		inputModels[index].textFieldValue = cell.inputTextFieldValue
		didCalculate()
	}
}

extension ViewController: IHistoryCellDelegate {
	
	// MARK: - IHistoryCellDelegate implementation
	
	func didSelectHistoryCell(_ historyCell: HistoryCellModel) {
		for item in 0...historyCell.inputValues.count-1 {
			inputModels[item].textFieldValue = historyCell.inputValues[item]
		}
		for item in 0...historyCell.outputValues.count-1 {
			outputModels[item].textFieldValue = historyCell.outputValues[item]
		}
		tableView.reloadData()
	}
}
