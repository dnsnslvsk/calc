//
//  TableFactory.swift
//  calc
//
//  Created by Nesiolovsky on 27.11.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.

import UIKit

final class TableFactory: UITableView {
    
    static func makeTable() -> UITableView {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        table.separatorInset = UIEdgeInsets.zero
        return table
    }
}
