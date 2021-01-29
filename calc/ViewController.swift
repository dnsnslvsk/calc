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
  let dimensions = Dimensions()
  
  var coefficient: Double = 1

  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let boltsCountDataSource = BoltsCountDataSource()
    inputModels = boltsCountDataSource.inputModels
    outputModels = boltsCountDataSource.outputModels
    configure()
  }
  
  
  // MARK: - Internal methods
  
  let tableView = TableFactory.makeTable()
  
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
      let D1 = Double(firstValue),
      let D2 = Double(secondValue),
      let P = Double(thirdValue),
      let d = Double(fourthValue),
      let στ = Double(fifthValue)
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
    configureTitle()
    configureLeftBarButton()
    configureRightBarButton()
    configureTable(tableView)
  }
  
  private func configureTitle() {
    self.navigationItem.title = "Количество болтов"
  }
  
  private func configureLeftBarButton() {
    let menuItem = UIBarButtonItem(title: "История", style: .plain, target: self, action: #selector(showHistory(_:)))
    navigationItem.setLeftBarButton(menuItem, animated: true)
  }
  
  private func configureRightBarButton() {
    let doneItem = UIBarButtonItem(title: "Расчеты", style: .plain, target: self, action: .none)
    navigationItem.setRightBarButton(doneItem, animated: true)
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
    self.present(vc, animated: true, completion: nil)
  }
}

/*
 
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
    currentRow = 0
  }
}
*/
 
 
// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
  
}

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
    cell.picker.isHidden = true
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
  
  
  
  func convert(_ model: CellModel, _ valueString: String) -> String {
    switch model.currentDimension.description {
    case "МПа":
      coefficient = 1
    case "Па":
      coefficient = 1000000
    case "psi":
      coefficient = 145.038
    case "атм":
      coefficient = 9.869
    case "мм":
      coefficient = 1
    case "дюйм":
      coefficient = 0.03937
    case "м":
      coefficient = 0.001
    default:
      coefficient = 100
    }
    let value = Double(valueString)
    guard let unwrappedValue = value else { return "" }
    let convertedValue = unwrappedValue * coefficient
    print (convertedValue)
    return String(convertedValue)
  }
}

// MARK: - ICellDelegate

extension ViewController: ICellDelegate {
  
  func didClickButton(_ cell: Cell) {
    guard let model = cell.model else { return }
    currentModel = model
    switch currentModel.parameterType {
    case .input:
      guard let index = inputModels.firstIndex(of: currentModel) else { return }
      inputModels[index].currentDimension = currentModel.currentDimension
    case .output:
      guard let index = outputModels.firstIndex(of: currentModel) else { return }
      outputModels[index].currentDimension = currentModel.currentDimension
    }
  }
  
  
  
  func didInputTextField(_ cell: Cell) {
    guard let model = cell.model else { return }
    currentModel = model
    guard let index = inputModels.firstIndex(of: currentModel) else { return }
    inputModels[index].parameterValue = cell.inputTextFieldValue
    didCalculate()
  }
  
  func didSelectPicker(_ cell: Cell) {
    
    guard let model = cell.model else { return }
    currentModel = model
    guard let index = inputModels.firstIndex(of: currentModel) else { return }
    inputModels[index].parameterValue = convert(currentModel, cell.inputTextFieldValue) //cell.inputTextFieldValue

    tableView.reloadData()
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
