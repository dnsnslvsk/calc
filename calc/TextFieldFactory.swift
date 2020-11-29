//
//  TextFieldFactory.swift
//  calc
//
//  Created by Nesiolovsky on 07.11.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//  

import UIKit

final class TexfFieldFactory {
    
    static func makeTextField() -> UITextField {
        let textField =  UITextField()
        textField.font = .systemFont(ofSize: 15)
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.keyboardType = .numbersAndPunctuation
        textField.returnKeyType = .continue
        textField.clearButtonMode = .always
        textField.textAlignment = .center
        return textField
    }
}
