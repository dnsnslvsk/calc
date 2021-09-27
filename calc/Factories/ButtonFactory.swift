//
//  BattonFactory.swift
//  calc
//
//  Created by Nesiolovsky on 11.11.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//  

import UIKit

final class ButtonFactory {
  
  static func makeButton() -> UIButton {
    let button = UIButton()
    button.setTitleColor(.label, for: .normal)
    return button
  }
}
