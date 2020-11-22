//
//  TextFieldFactory.swift
//  calc
//
//  Created by Nesiolovsky on 07.11.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//  

import UIKit

class TexfFieldFactory {
    
    static func makeTextField() -> UITextField {
        let textField =  UITextField()
        textField.font = .systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.numbersAndPunctuation
        textField.returnKeyType = UIReturnKeyType.continue
        textField.clearButtonMode = UITextField.ViewMode.always
        textField.textAlignment = .center
        return textField
    }
}
