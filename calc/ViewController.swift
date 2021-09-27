//
//  ViewController.swift
//  calc
//
//  Created by Nesiolovsky on 07.11.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
  
  // MARK: - Dependensies
  
  private let dimensionValidator = DimensionValidator()
  private let dimensionConverter = DimensionConverter()
  
  // MARK: - Private properties
  
  private let boltsCountDataSource = BoltsCountDataSource()
  private var inputModels: [CellModel] = []
  private var outputModels: [CellModel] = []
  private var calculateResults: [HistoryCellModel] = []
  private lazy var currentModel = inputModels[0]
  private var currentHistoryModel = HistoryCellModel(formattedResult: "", inputValues: [], outputValues: [])
  private var validatedDimension: Measurement<Dimension>?
  private var convertedValue: Measurement<Dimension>?
  private var buttonClicked: Bool?
  private let tableView = TableFactory.makeTable()
  
  // MARK: - Constants
  
  private let selectedCellHeight: CGFloat = 166.0
  private let unselectedCellHeight: CGFloat = 66.0
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    inputModels = boltsCountDataSource.inputModels
    outputModels = boltsCountDataSource.outputModels
    configure()
  }
  
  // MARK: - Private methods
  
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
  
  
  // MARK: - Configure
  
  private func configure() {
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
    cell.indexPath = indexPath.row
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
      validatedDimension = dimensionValidator.didValidateDimension(model: currentModel)
    case .output:
      guard let index = outputModels.firstIndex(of: currentModel) else { return }
      outputModels[index].parameterValue = currentModel.parameterValue
      if outputModels[index].isExpanded == .notExpandable { } else {
        outputModels[index].isExpanded = .didExpanded
      }
      validatedDimension = dimensionValidator.didValidateDimension(model: currentModel)
    }
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
      inputModels[index].parameterValue = dimensionConverter.convertValues(model: currentModel, validatedDimension: validatedDimension)
      inputModels[index].isExpanded = .notExpanded
      let indexPath = IndexPath(row: cell.indexPath, section: 0)
      tableView.reloadRows(at: [indexPath], with: .fade)
    case .output:
      guard let index = outputModels.firstIndex(of: currentModel) else { return }
      outputModels[index].currentDimension = currentModel.currentDimension
      outputModels[index].parameterValue = dimensionConverter.convertValues(model: currentModel, validatedDimension: validatedDimension)
      outputModels[index].isExpanded = .notExpanded
      let indexPath = IndexPath(row: cell.indexPath, section: 1)
      tableView.reloadRows(at: [indexPath], with: .fade)
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
