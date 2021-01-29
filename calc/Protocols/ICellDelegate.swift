//
//  ICellDelegate.swift
//  calc
//
//  Created by Денис Несиоловский on 28.12.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//

protocol ICellDelegate {
  func didClickButton(_ cell: Cell)
  func didInputTextField(_ cell: Cell)
  func didSelectPicker(_ cell: Cell)
}
