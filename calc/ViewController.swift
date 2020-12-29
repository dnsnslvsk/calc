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
        configure()
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
		let firstValue: String = inputModels[0].parameterValue
		let secondValue: String  = inputModels[1].parameterValue
		let thirdValue: String  = inputModels[2].parameterValue
		let fourthValue: String  = inputModels[3].parameterValue
		let fifthValue: String  = inputModels[4].parameterValue
		guard
			let D1 = Float(firstValue),
			let D2 = Float(secondValue),
			let P = Float(thirdValue),
			let d = Float(fourthValue),
			let στ = Float(fifthValue)
			else { return }
		let calcCore = BoltsCountCalculationCore(D1: D1, D2: D2, P: P, d: d, στ: στ)
		let result = calcCore.getFormattedResult()
		for item in 0...outputModels.count - 1 {
			outputModels[item].parameterValue = result[item]
		}
		tableView.reloadSections(IndexSet(integer: 1), with: .fade)
		calculateResults.append(calcCore.getResultForHistory())
	}
	
	// MARK: - Configure
	
	func configure() {
		configureCustomView(customView)
        configureTitle()
        configureLeftBarButton()
        configureRightBarButton()
		configureTable(tableView)
		configurePicker(picker)
	}
	
	private func configureCustomView(_ view: UIView) {
		customView.backgroundColor = .systemBackground
        customView.alpha = 0.9
	}
	
    private func configureTitle() {
        self.navigationItem.title = "Количество болтов"
    }

    private func configureLeftBarButton() {
         let menuItem = UIBarButtonItem(title: "Расчеты", style: .plain, target: self, action: .none)
         navigationItem.setLeftBarButton(menuItem, animated: true)
     }

     private func configureRightBarButton() {
         let doneItem = UIBarButtonItem(title: "История", style: .plain, target: self, action:  #selector(showHistory(_:)))
         navigationItem.setRightBarButton(doneItem, animated: true)
     }
    
	private func configurePicker(_ picker: UIPickerView) {
		picker.frame = CGRect(x: 0, y: view.bounds.height/2, width: view.bounds.width, height: 100)
        picker.delegate = self
        picker.dataSource = self
	}
	
	private func configureTable(_ table: UITableView) {
		table.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
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

// MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDataSource {

    func numberOfComponents(in picker: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ picker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return currentModel.avaliableDimensions.count
	}
}

// MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDelegate {
		
	func pickerView(_ picker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return currentModel.avaliableDimensions[row].description
	}
	
	func pickerView(_ picker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentModel.parameterType == ParameterType.input {
			guard let index = inputModels.firstIndex(of: currentModel) else { return }
			inputModels[index].currentDimension = currentModel.avaliableDimensions[row]
        } else if currentModel.parameterType == ParameterType.output {
			guard let index = outputModels.firstIndex(of: currentModel) else { return }
			outputModels[index].currentDimension = currentModel.avaliableDimensions[row]
		}
		tableView.reloadData()
		picker.isHidden = true
		customView.isHidden = true
		currentRow = 0
	}
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate { }

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
	
	
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
			let model = inputModels[indexPath.row]
			cell.setNameParameterLabel(model.parameterName)
			cell.setNameDimensionButton(model.currentDimension.description)
			cell.setValue(model.parameterValue)
			cell.model = model
			return cell
		case 1:
			let model = outputModels[indexPath.row]
			cell.setNameParameterLabel(model.parameterName)
			cell.setNameDimensionButton(model.currentDimension.description)
			cell.setValue(model.parameterValue)
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

// MARK: - ICellDelegate

extension ViewController: ICellDelegate {
	
	func didSelectCell(_ cell: Cell) {
		guard let model = cell.model else { return }
		currentModel = model
		picker.reloadAllComponents()
		picker.isHidden = false
		self.view.addSubview(customView)
		customView.isHidden = false
		
		for i in 0...currentModel.avaliableDimensions.count - 1 {
            if currentModel.currentDimension.description == currentModel.avaliableDimensions[i].description {
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
		inputModels[index].parameterValue = cell.inputTextFieldValue
		didCalculate()
	}
}

// MARK: - IHistoryCellDelegate

extension ViewController: IHistoryCellDelegate {
	func didSelectHistoryCell(_ historyCell: HistoryCellModel) {
		for item in 0...historyCell.inputValues.count - 1 {
			inputModels[item].parameterValue = historyCell.inputValues[item]
		}
		for item in 0...historyCell.outputValues.count - 1 {
			outputModels[item].parameterValue = historyCell.outputValues[item]
		}
		tableView.reloadData()
	}
}
