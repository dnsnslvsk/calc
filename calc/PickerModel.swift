//
//  PickerModel.swift
//  calc
//
//  Created by Nesiolovsky on 01.12.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//

import Foundation

struct PickerModel {
    
    var parameterName: String
    var currentButtonName: CustomStringConvertible
    var mode: Mode
    var dataSourceArray: [CustomStringConvertible]
    var inputTextFieldValue: String
}

    //MARK: - Dimensions
    
enum Mode {
    case mass
    case length
}

    //MARK: - Mass dimensions
    
enum Mass: String, CustomStringConvertible {
    case kg = "кг"
    case t = "т"
    case g = "г"
    case N = "Н"
var description: String { rawValue }
}
    
    //MARK: - Lenght dimensions
    
enum Length: String, CustomStringConvertible {
    case mm = "мм"
    case cm = "см"
    case m = "м"
var description: String { rawValue }
}
