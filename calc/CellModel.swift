//
//  PickerModel.swift
//  calc
//
//  Created by Nesiolovsky on 01.12.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//

import Foundation

struct CellModel: Equatable {
	static func == (lhs: CellModel, rhs: CellModel) -> Bool {
		return rhs.id == lhs.id
	}
	let id = UUID()
	var parameterName: String
	var currentButtonName: CustomStringConvertible
	var dataSourceArray: [CustomStringConvertible]
	var textFieldValue: String
	var sectionNumber: Int
}
