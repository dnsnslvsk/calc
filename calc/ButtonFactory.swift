//
//  BattonFactory.swift
//  calc
//
//  Created by Nesiolovsky on 11.11.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//  

import UIKit

class ButtonFactory {
    
    // MARK: - Configure
    
    static func makeButton(frame: CGRect, name: String) -> UIButton {
        let button = UIButton()
        button.frame = frame
        button.backgroundColor = UIColor.black
        button.setTitle(name, for: .normal)
        return button
    }
}
