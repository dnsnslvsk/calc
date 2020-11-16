//
//  LableFactory.swift
//  calc
//
//  Created by Nesiolovsky on 08.11.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//  

import UIKit

class LableFactory {
    
    // MARK: - Configure
    
    static func makeLable(frame: CGRect, name: String) -> UILabel {
        let label = UILabel(frame: frame)
        label.textAlignment = .center
        label.text = name
        label.backgroundColor = .systemGray
        return label
    }
}
