//
//  CellFactory.swift
//  calc
//
//  Created by Nesiolovsky on 27.11.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//

import UIKit

class CellFactory: UITableViewCell {
    
    struct cellModel {
        var parameterLabel: UILabel
        var dimensionButton: UIButton
        var inputTextField: UITextField
    }
    

    var parameterLabel = LabelFactory.makeLabel()
    var dimensionButton = ButtonFactory.makeButton()
    var inputTextField = TexfFieldFactory.makeTextField()
    
    lazy var cellModelForChange = CellFactory.cellModel(parameterLabel: parameterLabel, dimensionButton: dimensionButton, inputTextField: inputTextField)

    func set(_ object: cellModel) {
        cellModelForChange = object
        
        object.parameterLabel.frame = CGRect(x: 0, y: 0, width: 100, height: ViewController.Constant.tableViewEstimatedRowHeight-6)
        addSubview(object.parameterLabel)
        
        object.dimensionButton.frame = CGRect(x: 100, y: 0, width: 100, height:ViewController.Constant.tableViewEstimatedRowHeight-6)
        addSubview(object.dimensionButton)
        
        object.inputTextField.frame = CGRect(x: 200, y: 0, width: 100, height: ViewController.Constant.tableViewEstimatedRowHeight-6)
        addSubview(object.inputTextField)
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
