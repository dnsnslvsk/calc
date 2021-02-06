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
  var qwe: Any?
  var currentDimension: CustomStringConvertible
  var currentDimensionStress: Dimensions.StressAndPressure?
  var currentDimensionLength: Dimensions.Diameter?
  var avaliableDimensions: [CustomStringConvertible]
  var avaliableDimensionsStress: Dimensions.StressAndPressure?
  var avaliableDimensionsLength: Dimensions.Diameter?
	var parameterValue: String
  var parameterType: ParameterType
}




enum ParameterType {
    case input
    case output
}




