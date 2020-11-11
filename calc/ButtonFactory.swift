//
//  BattonFactory.swift
//  calc
//
//  Created by Nesiolovsky on 11.11.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//

import UIKit

class ButtonFactory {
    static func makeButton(frame: CGRect, name: String) -> UIButton {
        let button = UIButton()
        button.frame = frame
        button.backgroundColor = UIColor.red
        button.setTitle(name, for: .normal)
        return button
    }
}
