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
	var mode: Mode
	var dataSourceArray: [CustomStringConvertible]
	var textFieldValue: String
}

//MARK: - Dimensions

enum Mode {
	case stressAndPressure
	case diameter
}

//MARK: - Mass dimensions

enum StressAndPressure: String, CustomStringConvertible {
	case MPa = "МПа"
	case Pa = "Па"
	case psi = "psi"
	case bar = "атм"
	var description: String { rawValue }
}

//MARK: - Lenght dimensions

enum Diameter: String, CustomStringConvertible {
	case mm = "мм"
	case inch = "дюйм"
	case m = "м"
	var description: String { rawValue }
}
