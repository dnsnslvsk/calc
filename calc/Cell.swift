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
	var inputTextFieldValue = ""
	
	// MARK: - Public methods

	var parameterLabel = LabelFactory.makeLabel()
	var dimensionButton = ButtonFactory.makeButton()
	var inputTextField = TexfFieldFactory.makeTextField()
	
	// MARK: - Initialization

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configure()
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
	func setValueInputTextFiled(_ value: String?) {
		inputTextField.text = value
	}
	
	// MARK: - Configure
	
	func configure() {
		configureParameterLabel(parameterLabel)
		configureDimensionButton(dimensionButton)
		configureInputTextField(inputTextField)
	}
	
	private func configureParameterLabel(_ label: UILabel) {
		parameterLabel.frame = CGRect(x: 10, y: 0, width: 205, height: ViewController.Constant.tableViewEstimatedRowHeight-6)
		parameterLabel.textAlignment = .left
		addSubview(parameterLabel)
	}
	
	private func configureDimensionButton(_ button: UIButton) {
		dimensionButton.frame = CGRect(x: 215, y: 0, width: 50, height: ViewController.Constant.tableViewEstimatedRowHeight-6)
		dimensionButton.addTarget(self, action: #selector(dimensionButtonAction(_ :)), for: .touchUpInside)
		addSubview(dimensionButton)
	}
	
	private func configureInputTextField(_ textField: UITextField) {
		inputTextField.frame = CGRect(x: 265, y: 0, width: 100, height: ViewController.Constant.tableViewEstimatedRowHeight-6)
		inputTextField.addTarget(self, action: #selector(inputTextFieldAction(_ :)), for: .editingDidEnd)
		addSubview(inputTextField)
	}
	
	// MARK: - Actions

	@objc
	private func dimensionButtonAction(_: UIButton) {
		delegate?.didSelectCell(self)
	}
	
	@objc
	private func inputTextFieldAction(_: UITextField) {
		guard let value = inputTextField.text else { return }
		inputTextFieldValue = value
		delegate?.didInputTextField(self)
	}
}

// MARK: - ICellDelegate

protocol ICellDelegate {
	func didSelectCell(_ cell: Cell)
	func didInputTextField(_ cell: Cell)
}


