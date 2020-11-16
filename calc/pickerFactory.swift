//
//  pickerFactory.swift
//  calc
//
//  Created by Nesiolovsky on 08.11.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//  

import UIKit

class PickerFactory {
    
    // MARK: - Configure
    
    static func makePicker(frame: CGRect) -> UIPickerView {
        let picker = UIPickerView()
        picker.frame = frame
        return picker
    }
}
