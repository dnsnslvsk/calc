//
//  LableFactory.swift
//  calc
//
//  Created by Nesiolovsky on 08.11.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//  

import UIKit

class LabelFactory {
    
    static func makeLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .secondaryLabel
        return label
    }
}
