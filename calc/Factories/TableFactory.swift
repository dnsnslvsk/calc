//
//  TableFactory.swift
//  calc
//
//  Created by Nesiolovsky on 27.11.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.

import UIKit

final class TableFactory: UITableView {
  
  static func makeTable() -> UITableView {
    let table = UITableView(frame: CGRect.zero, style: .grouped)
    table.separatorInset = UIEdgeInsets.zero
    table.rowHeight = UITableView.automaticDimension
    return table
  }
}
