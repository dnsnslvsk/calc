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
  var validatedDimension: Measurement<Dimension>?
  var convertedValue: Measurement<Dimension>?
  var buttonClicked: Bool?
  let tableView = TableFactory.makeTable()

  let selectedCellHeight: CGFloat = 166.0
  let unselectedCellHeight: CGFloat = 66.0
  
  
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let calculate = BoltsCountDataSource()
    inputModels = calculate.inputModels
    outputModels = calculate.outputModels
    configure()
  }
  
//  override func viewWillAppear(_ animated: Bool) {
//    tableView.estimatedRowHeight = 300
//    tableView.rowHeight = UITableView.automaticDimension
//  }
  
  // MARK: - Internal methods
  
  
  private func didCalculate() {
    var inputValues: [Double] = []
    for item in 0...inputModels.count - 1 {
      guard let doubleValue = Double(inputModels[item].parameterValue) else { return }
      inputValues.append(doubleValue)
    }
    let calculationCore = BoltsCountCalculationCore(inputValues: inputValues)
    
    let result = calculationCore.getFormattedResult()
    for item in 0...outputModels.count - 1 {
      outputModels[item].parameterValue = result[item]
    }
    tableView.reloadSections(IndexSet(integer: 1), with: .fade)
    calculateResults.append(calculationCore.getResultForHistory())
  }
  
  func didValidateDimension(model: CellModel) {
    guard let unwrappedValue = Double(model.parameterValue) else { return }
      switch model.currentDimension.description {
      case "МПа":
        validatedDimension = Measurement(value: unwrappedValue, unit: UnitPressure.megapascals)
      case "Па":
        validatedDimension = Measurement(value: unwrappedValue, unit: UnitPressure.newtonsPerMetersSquared)
      case "psi":
        validatedDimension = Measurement(value: unwrappedValue, unit: UnitPressure.poundsForcePerSquareInch)
      case "атм":
        validatedDimension = Measurement(value: unwrappedValue, unit: UnitPressure.bars)
      case "мм":
        validatedDimension = Measurement(value: unwrappedValue, unit: UnitLength.millimeters)
      case "дюйм":
        validatedDimension = Measurement(value: unwrappedValue, unit: UnitLength.inches)
      case "м":
        validatedDimension = Measurement(value: unwrappedValue, unit: UnitLength.meters)
      default:
        return
      }
  }
  
  func convertValues(model: CellModel) -> String {
    let model = currentModel
    guard let unwrappedValidatedDimension = validatedDimension else { return "" }
    switch unwrappedValidatedDimension.unit {
    case is UnitPressure:
      switch model.currentDimension.description {
      case "МПа":
        convertedValue = unwrappedValidatedDimension.converted(to: UnitPressure.megapascals)
      case "Па":
        convertedValue = unwrappedValidatedDimension.converted(to: UnitPressure.newtonsPerMetersSquared)
      case "psi":
        convertedValue = unwrappedValidatedDimension.converted(to: UnitPressure.poundsForcePerSquareInch)
      case "атм":
        convertedValue = unwrappedValidatedDimension.converted(to: UnitPressure.bars)
      default:
        return ""
      }
    case is UnitLength:
      switch model.currentDimension.description {
      case "мм":
        convertedValue = unwrappedValidatedDimension.converted(to: UnitLength.millimeters)
      case "дюйм":
        convertedValue = unwrappedValidatedDimension.converted(to: UnitLength.inches)
      case "м":
        convertedValue = unwrappedValidatedDimension.converted(to: UnitLength.meters)
      default:
        return ""
      }
    default:
      return ""
    }
//    let formatter = MeasurementFormatter()
//    formatter.unitStyle = .short
//    formatter.unitOptions = .providedUnit
//    formatter.locale = .current
//    if validatedDimensionPressure == Measurement(value: 0, unit: UnitPressure.gigapascals) {
//      print(round(1000*convertedValueLength.value)/1000, convertedValueLength.unit)
//      let result = formatter.string(from: convertedValueLength)
//      let formattedResult = String(result.filter { "01234567890.".contains($0) })
//      print(formattedResult)
//      return formattedResult
//    } else {
//      print(convertedValuePressure)
//      let result = formatter.string(from: convertedValuePressure)
//      let formattedResult = String(result.filter { "01234567890.".contains($0) })
//      return formattedResult
//    }
    guard let unwrappedConvertedValue = convertedValue?.value else { return "" }
    let result = String(round(100*unwrappedConvertedValue)/100)
    return result
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
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    if selectedCellIndexPath != nil && selectedCellIndexPath! as IndexPath == indexPath {
//        selectedCellIndexPath = nil
//    } else {
//        selectedCellIndexPath! as IndexPath = indexPath
//    }
//
//    tableView.beginUpdates()
//    tableView.endUpdates()
//
//    if selectedCellIndexPath != nil {
//      tableView.scrollToRow(at: indexPath, at: .none, animated: true)
//    }
  }
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
  
//  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//    self.tableView.estimatedRowHeight = 80 // or any other number that makes sense for your cells
//    self.tableView.rowHeight = UITableView.automaticDimension
//    return UITableView.automaticDimension
//  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      let model = inputModels[indexPath.row]
      switch model.isExpanded {
      case .didExpanded:
        return selectedCellHeight
      case .notExpanded:
        return unselectedCellHeight
      case .notExpandable:
        return unselectedCellHeight
      }
    case 1:
      let model = outputModels[indexPath.row]
      switch model.isExpanded {
      case .didExpanded:
        return selectedCellHeight
      case .notExpanded:
        return unselectedCellHeight
      case .notExpandable:
        return unselectedCellHeight
      }
    default:
      return 0
    }
    
//    if selectedCellIndexPath! as IndexPath == indexPath {
//        return selectedCellHeight
//    }
//    return unselectedCellHeight
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
      inputModels[index].parameterValue = currentModel.parameterValue
      inputModels[index].isExpanded = .didExpanded
      didValidateDimension(model: currentModel)
    case .output:
      guard let index = outputModels.firstIndex(of: currentModel) else { return }
      outputModels[index].parameterValue = currentModel.parameterValue
      outputModels[index].isExpanded = .didExpanded
      didValidateDimension(model: currentModel)
    }
    print ("row selected")
    buttonClicked = true
    tableView.beginUpdates()
    tableView.endUpdates()
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
      inputModels[index].isExpanded = .notExpanded
      tableView.reloadData()
    case .output:
      guard let index = outputModels.firstIndex(of: currentModel) else { return }
      outputModels[index].currentDimension = currentModel.currentDimension
      outputModels[index].parameterValue = convertValues(model: currentModel)
      outputModels[index].isExpanded = .notExpanded

      tableView.reloadSections(IndexSet(integer: 1), with: .fade)
    }
    buttonClicked = false
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



