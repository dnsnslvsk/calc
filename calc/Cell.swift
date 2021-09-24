//
//  CellFactory.swift
//  calc
//
//  Created by Nesiolovsky on 27.11.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//

import UIKit

final class Cell: UITableViewCell {
	
	// MARK: - Internal properties
  
	var model: CellModel?
	var delegate: ICellDelegate?
  var parameterLabel = LabelFactory.makeLabel()
	var dimensionButton = ButtonFactory.makeButton()
	var inputTextField = TexfFieldFactory.makeTextField()
  let picker = PickerFactory.makePicker()
  var currentRowCounter = 0
	
	// MARK: - Lifecycle

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
    inputTextField.delegate = self
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Internal methods
	
	func setNameParameterLabel(_ name: String?) {
		parameterLabel.text = name
	}
	func setNameDimensionButton(_ name: String?) {
		dimensionButton.setTitle(name, for: .normal)
	}
	func setValue(_ value: String?) {
		inputTextField.text = value
	}
	
	// MARK: - Configure
	
	private func configure() {
		configureParameterLabel(parameterLabel)
    configureParameterLabelConstraints()
		configureDimensionButton(dimensionButton)
    configureDimensionButtonConstraints()
		configureInputTextField(inputTextField)
    configureInputTextFieldConstraints()
    configurePicker(picker)
    configurePickerConstraints()
	}
	
	private func configureParameterLabel(_ label: UILabel) {
    label.frame = CGRect.zero
    label.textAlignment = .left
    contentView.addSubview(label)
	}
	
	func configureDimensionButton(_ button: UIButton) {
    button.frame = CGRect.zero
    button.addTarget(self, action: #selector(dimensionButtonAction(_ :)), for: .touchUpInside)
    contentView.addSubview(button)
	}
	
	private func configureInputTextField(_ textField: UITextField) {
    //textField.backgroundColor = .cyan
    textField.frame = CGRect.zero
    textField.keyboardType = .default
    textField.addTarget(self, action: #selector(inputTextFieldAction(_ :)), for: .editingDidEnd)
    contentView.addSubview(textField)
	}
  
  private func configurePicker(_ picker: UIPickerView) {
    picker.delegate = self
    picker.dataSource = self
    picker.isHidden = false
    //picker.backgroundColor = .brown
    contentView.addSubview(picker)
  }
  
  // MARK: - Constraints
  
  private func configureParameterLabelConstraints() {
    parameterLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      parameterLabel.heightAnchor.constraint(
        equalToConstant: 50),
      parameterLabel.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: 8),
      parameterLabel.rightAnchor.constraint(
        equalTo: parameterLabel.leftAnchor,
        constant: 200),
      parameterLabel.leftAnchor.constraint(
        equalTo: contentView.leftAnchor,
        constant: 10),
    ])
  }
  
  func configureDimensionButtonConstraints() {
    dimensionButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dimensionButton.topAnchor.constraint(
        equalTo: parameterLabel.topAnchor,
        constant: 0),
      dimensionButton.rightAnchor.constraint(
        equalTo: contentView.rightAnchor,
        constant: -110),
      dimensionButton.bottomAnchor.constraint(
        equalTo: parameterLabel.bottomAnchor,
        constant: 0),
      dimensionButton.leftAnchor.constraint(
        equalTo: dimensionButton.rightAnchor,
        constant: -50)
    ])
  }
  
  func configureInputTextFieldConstraints() {
    inputTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
//      inputTextField.heightAnchor.constraint(
//        equalToConstant: 50),
      inputTextField.topAnchor.constraint(
        equalTo: parameterLabel.topAnchor,
        constant: 0),
      inputTextField.bottomAnchor.constraint(
        equalTo: parameterLabel.bottomAnchor,
        constant: 0),
      inputTextField.leftAnchor.constraint(
        equalTo: inputTextField.rightAnchor,
        constant: -100),
      inputTextField.rightAnchor.constraint(
        equalTo: contentView.rightAnchor,
        constant: -10)
    ])
  }
  
  func configurePickerConstraints() {
    picker.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      picker.heightAnchor.constraint(
        equalToConstant: 100),
      picker.topAnchor.constraint(
        equalTo: parameterLabel.bottomAnchor,
        constant: 0),
      picker.rightAnchor.constraint(
        equalTo: contentView.rightAnchor,
        constant: -10),
      picker.leftAnchor.constraint(
        equalTo: contentView.leftAnchor,
        constant: 10)
    ])
  }
  
  	// MARK: - Actions

	@objc
  func dimensionButtonAction(_: UIButton) {
    guard let unwrappedModel = model else { return }
    for i in 0...unwrappedModel.avaliableDimensions.count - 1 {
      if dimensionButton.titleLabel?.text == unwrappedModel.avaliableDimensions[i].description {
        picker.selectRow(currentRowCounter, inComponent: 0, animated: false)
        break
      } else { currentRowCounter += 1 }
    }
    guard let value = inputTextField.text else { return }
    model?.parameterValue = value
    delegate?.didClickButton(self)
    model?.isExpanded = .didExpanded
    picker.reloadAllComponents()
    picker.isHidden = false
  }
	
	@objc
	private func inputTextFieldAction(_: UITextField) {
		guard let value = inputTextField.text else { return }
    model?.parameterValue = value
		delegate?.didInputTextField(self)
	}
}

// MARK: - UIPickerViewDelegate

extension Cell: UIPickerViewDataSource {
  
  func numberOfComponents(in picker: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ picker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    guard let unwrappedModel = model else { return 0 }
    return unwrappedModel.avaliableDimensions.count
  }
}

// MARK: - UIPickerViewDataSource

extension Cell: UIPickerViewDelegate {
  
  func pickerView(_ picker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    guard let unwrappedModel = model else { return "" }
    return unwrappedModel.avaliableDimensions[row].description
  }
  
  func pickerView(_ picker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    guard let unwrappedModel = model else { return }
    dimensionButton.setTitle(unwrappedModel.avaliableDimensions[row].description, for: .normal)
    model?.currentDimension = unwrappedModel.avaliableDimensions[row]
    delegate?.didSelectPicker(self)
    currentRowCounter = 0
    picker.isHidden = true
    model?.isExpanded = .notExpanded
    
  }
}

extension Cell: UITextFieldDelegate {
  func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
      self.contentView.endEditing(true)
      return true
  }
}

