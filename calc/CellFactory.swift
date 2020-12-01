//
//  CellFactory.swift
//  calc
//
//  Created by Nesiolovsky on 27.11.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//

import UIKit

final class CellFactory: UITableViewCell {

    var delegate: ISetPicker?
    
    @objc
    private func dimensionButtonAction(_ : UIButton) {
        delegate!.callPicker()
    }
    
    
    var parameterLabel = LabelFactory.makeLabel()
    var dimensionButton = ButtonFactory.makeButton()
    var inputTextField = TexfFieldFactory.makeTextField()
    

    func setNameParameterLabel(_ name: String?) {
        parameterLabel.text = name
    }
    
    func setNameDimensionButton() {
    }
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        parameterLabel.frame = CGRect(x: 0, y: 0, width: 100, height: ViewController.Constant.tableViewEstimatedRowHeight-6)
        addSubview(parameterLabel)

        dimensionButton.setTitle("dimension", for: .normal)
        dimensionButton.frame = CGRect(x: 120, y: 0, width: 120, height:ViewController.Constant.tableViewEstimatedRowHeight-6)
        dimensionButton.addTarget(self, action: #selector(dimensionButtonAction(_ :)), for: .touchUpInside)
        addSubview(dimensionButton)
        
        inputTextField.frame = CGRect(x: 240, y: 0, width: 120, height: ViewController.Constant.tableViewEstimatedRowHeight-6)
        inputTextField.placeholder = "0"
        addSubview(inputTextField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol ISetPicker {
    func callPicker()
}
