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
  
  
  var validatedDimensionPressure = Measurement(value: 0, unit: UnitPressure.gigapascals)
  var validatedDimensionLength = Measurement(value: 0, unit: UnitLength.millimeters)
  
  lazy var convertedValuePressure = Measurement(value: 0, unit: UnitPressure.megapascals)
  lazy var convertedValueLength = Measurement(value: 0, unit: UnitLength.millimeters)
  
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
  
//  enum Constant {
//    static let tableViewEstimatedRowHeight = 50
//  }
  
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
  
  func validationDimension(model: CellModel) {
    guard let unwrappedValue = Double(model.parameterValue) else { return }
    switch model.currentDimension.description {
    case "МПа":
      validatedDimensionPressure = Measurement(value: unwrappedValue, unit: UnitPressure.megapascals)
    case "Па":
      validatedDimensionPressure = Measurement(value: unwrappedValue, unit: UnitPressure.megapascals) * 1000000
    case "psi":
      validatedDimensionPressure = Measurement(value: unwrappedValue, unit: UnitPressure.poundsForcePerSquareInch)
    case "атм":
      validatedDimensionPressure = Measurement(value: unwrappedValue, unit: UnitPressure.bars)
    case "мм":
      validatedDimensionLength = Measurement(value: unwrappedValue, unit: UnitLength.millimeters)
    case "дюйм":
      validatedDimensionLength = Measurement(value: unwrappedValue, unit: UnitLength.inches)
    case "м":
      validatedDimensionLength = Measurement(value: unwrappedValue, unit: UnitLength.meters)
    default:
      return
    }
  }
  
  func convertValues(model: CellModel) -> String {
    let model = currentModel
    ///как упаковать все размерности в unwrappedValidatedDimension без указания unit
    let unwrappedValidatedDimensionPressure = validatedDimensionPressure
    let unwrappedValidatedDimensionLenght = validatedDimensionLength
    switch model.currentDimension.description {
    case "МПа":
      convertedValuePressure = unwrappedValidatedDimensionPressure.converted(to: UnitPressure.megapascals)
    case "Па":
      convertedValuePressure = unwrappedValidatedDimensionPressure.converted(to: UnitPressure.megapascals) * 1000000
    case "psi":
      convertedValuePressure = unwrappedValidatedDimensionPressure.converted(to: UnitPressure.poundsForcePerSquareInch)
    case "атм":
      convertedValuePressure = unwrappedValidatedDimensionPressure.converted(to: UnitPressure.bars)
    case "мм":
      convertedValueLength = unwrappedValidatedDimensionLenght.converted(to: UnitLength.millimeters)
    case "дюйм":
      convertedValueLength = unwrappedValidatedDimensionLenght.converted(to: UnitLength.inches)
    case "м":
      convertedValueLength = unwrappedValidatedDimensionLenght.converted(to: UnitLength.meters)
    default:
      return ""
    }
    
    let formatter = MeasurementFormatter()
    formatter.unitStyle = .short
    formatter.unitOptions = .providedUnit
    formatter.locale = .current
    if validatedDimensionPressure == Measurement(value: 0, unit: UnitPressure.gigapascals) {
      print(round(1000*convertedValueLength.value)/1000, convertedValueLength.unit)
      let result = formatter.string(from: convertedValueLength)
      let formattedResult = String(result.filter { "01234567890.".contains($0) })
      print(formattedResult)
      return formattedResult
    } else {
      print(convertedValuePressure)
      let result = formatter.string(from: convertedValuePressure)
      let formattedResult = String(result.filter { "01234567890.".contains($0) })
      return formattedResult
    }
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
  
//  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> Int {
//    return Constant.tableViewEstimatedRowHeight
//  }
}

// MARK: - ICellDelegate

extension ViewController: ICellDelegate {
  
  func didClickButton(_ cell: Cell) {
    guard let model = cell.model else { return }
    currentModel = model
    switch currentModel.parameterType {
    case .input:
      guard let index = inputModels.firstIndex(of: currentModel) else { return }
      inputModels[index].parameterValue = currentModel.parameterValue
      validationDimension(model: currentModel)
    case .output:
      guard let index = outputModels.firstIndex(of: currentModel) else { return }
      outputModels[index].parameterValue = currentModel.parameterValue
      validationDimension(model: currentModel)
    }
    print(currentModel.parameterValue)
  }
  
  func didSelectPicker(_ cell: Cell) {
    guard let model = cell.model else { return }
    currentModel = model
    switch currentModel.parameterType {
    case .input:
      guard let index = inputModels.firstIndex(of: currentModel) else { return }
      inputModels[index].currentDimension = currentModel.currentDimension
      inputModels[index].parameterValue = convertValues(model: currentModel)
      tableView.reloadData()
    case .output:
      guard let index = outputModels.firstIndex(of: currentModel) else { return }
      outputModels[index].currentDimension = currentModel.currentDimension
      outputModels[index].parameterValue = convertValues(model: currentModel)
      tableView.reloadSections(IndexSet(integer: 1), with: .fade)
    }
  }
  
  func didInputTextField(_ cell: Cell) {
    guard let model = cell.model else { return }
    currentModel = model
    guard let index = inputModels.firstIndex(of: currentModel) else { return }
    inputModels[index].parameterValue = currentModel.parameterValue
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



