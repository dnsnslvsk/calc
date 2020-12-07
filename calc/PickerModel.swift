//
//  PickerModel.swift
//  calc
//
//  Created by Nesiolovsky on 01.12.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//

import Foundation


struct PickerModel {
    var mode: Mode
    var dataSourceArray: [String]
    var currentButtonName: String
    var parameterName: String
    var inputTextFieldValue: String
}

    
    //MARK: - Lenght dimensions
    
enum Mode {
    case mass
    case length
}
