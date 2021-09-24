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
  var currentDimension: CustomStringConvertible
  var avaliableDimensions: [CustomStringConvertible]
	var parameterValue: String
  var parameterType: ParameterType
  var isExpanded: Extensibility
}

enum ParameterType {
    case input
    case output
}

enum Extensibility {
    case didExpanded
    case notExpanded
    case notExpandable
}


