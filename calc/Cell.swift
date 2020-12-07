//
//  CellFactory.swift
//  calc
//
//  Created by Nesiolovsky on 27.11.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//

import UIKit

final class Cell: UITableViewCell {
    
    var mode: Mode?
    var delegate: ISetPicker?
    var inputTextFieldValue = ""
    
    @objc
    private func dimensionButtonAction(_ : UIButton) {
        delegate?.didSelectCell(self)
    }
    
    @objc
    private func inputTextFieldAction(_ : UIButton) {
        delegate?.didInputTextField(self)
        guard let value = inputTextField.text else { return }
        inputTextFieldValue = value
    }
    
    var parameterLabel = LabelFactory.makeLabel()
    var dimensionButton = ButtonFactory.makeButton()
    var inputTextField = TexfFieldFactory.makeTextField()

    func setNameParameterLabel(_ name: String?) {
        parameterLabel.text = name
    }
    
    func setNameDimensionButton(_ name: String?) {
        dimensionButton.setTitle(name, for: .normal)
    }
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        parameterLabel.frame = CGRect(x: 0, y: 0, width: 100, height: ViewController.Constant.tableViewEstimatedRowHeight-6)
        parameterLabel.textAlignment = .left
        addSubview(parameterLabel)

        
        dimensionButton.frame = CGRect(x: 120, y: 0, width: 120, height:ViewController.Constant.tableViewEstimatedRowHeight-6)
        dimensionButton.addTarget(self, action: #selector(dimensionButtonAction(_ :)), for: .touchUpInside)
        addSubview(dimensionButton)
        
        inputTextField.frame = CGRect(x: 240, y: 0, width: 120, height: ViewController.Constant.tableViewEstimatedRowHeight-6)
        inputTextField.addTarget(self, action: #selector(inputTextFieldAction(_ :)), for: .allEditingEvents)
        inputTextField.placeholder = "0"
        addSubview(inputTextField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol ISetPicker {
    func didSelectCell(_ cell: Cell)
    func didInputTextField(_ cell: Cell)
}


