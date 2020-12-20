//
//  BoltsContCalcCore.swift
//  calc
//
//  Created by Nesiolovsky on 10.12.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//

import Foundation

final class BoltsCountDataSource {
	
	let dimensions = Dimensions()
	
	lazy var inputModels = [
		CellModel(
			parameterName: "Больший диаметр, D1",
			currentButtonName: dimensions.diameterArray[0],
			dataSourceArray: dimensions.diameterArray,
			textFieldValue: ""),
		CellModel(
			parameterName: "Меньший диаметер, D2",
			currentButtonName: dimensions.diameterArray[0],
			dataSourceArray: dimensions.diameterArray,
			textFieldValue: ""),
		CellModel(
			parameterName: "Давление, P",
			currentButtonName: dimensions.stressAndPressureArray[0],
			dataSourceArray: dimensions.stressAndPressureArray,
			textFieldValue: ""),
		CellModel(
			parameterName: "Диаметр срезного элемента, d",
			currentButtonName: dimensions.diameterArray[0],
			dataSourceArray: dimensions.diameterArray,
			textFieldValue: ""),
		CellModel(
			parameterName: "Доп. напряжение на срез, [σ]τ",
			currentButtonName: dimensions.stressAndPressureArray[0],
			dataSourceArray: dimensions.stressAndPressureArray,
			textFieldValue: "")
	]
	
	lazy var outputModels = [
		CellModel(
			parameterName: "Площадь под давлением, S1",
			currentButtonName: dimensions.diameterArray[0],
			dataSourceArray: dimensions.diameterArray,
			textFieldValue: ""),
		CellModel(
			parameterName: "Сечение крепежа, S2",
			currentButtonName: dimensions.diameterArray[0],
			dataSourceArray: dimensions.diameterArray,
			textFieldValue: ""),
		CellModel(
			parameterName: "Сила от давления, F1",
			currentButtonName: dimensions.stressAndPressureArray[0],
			dataSourceArray: dimensions.stressAndPressureArray,
			textFieldValue: ""),
		CellModel(
			parameterName: "Сила среза крепежа, F2",
			currentButtonName: dimensions.stressAndPressureArray[0],
			dataSourceArray: dimensions.stressAndPressureArray,
			textFieldValue: ""),
		CellModel(
			parameterName: "Количество болтов, n",
			currentButtonName: dimensions.stressAndPressureArray[0],
			dataSourceArray: dimensions.stressAndPressureArray,
			textFieldValue: "")
	]
}

final class BoltsCountCalculationCore {
	
	let D1: Float
	let D2: Float
	let P: Float
	let d: Float
	let στ: Float
	
	var result: [String] = []
	
	internal init(D1: Float, D2: Float, P: Float, d: Float, στ: Float) {
		self.D1 = D1
		self.D2 = D2
		self.P = P
		self.d = d
		self.στ = στ
	}
	
	var S1: Float = 0
	var S2: Float = 0
	var F1: Float = 0
	var F2: Float = 0
	var n: Float = 0
	var resultForHistory: [String] = []
	
	func calculate() -> [Float] {
		S1 = round(Float.pi * ((D1*D1)/4 - (D2*D2)/4))
		S2 = round(Float.pi * d * d / 4)
		F1 = round(S1 * P)
		F2 = round(στ * S2)
		n = round(F1/F2)
		return [S1, S2, F1, F2, n]
	}
	
	func getFormattedResult() -> [String] {
		for item in calculate() {
			result.append("\(item)")
		}
		return result
	}
	
	
	func getResultForHistory() -> HistoryCellModel {
		resultForHistory = getFormattedResult()
		let historyModel = HistoryCellModel(
			formattedResult:
			"""
			ИСХОДНЫЕ ДАННЫЕ:
			Больший диаметр, D1 = \(D1) мм
			Меньший диаметр, D2 =  \(D2) мм
			Давление, P =  \(P) МПа
			Диаметр срезного элемента, d =  \(d) мм
			Доп. напряжение на срез, [σ]τ =  \(στ) МПа
			
			РЕЗУЛЬТАТ:
			Площадь под давлением, S1 =  \(resultForHistory[0]) мм²
			Сечение крепежа, S2 =  \(resultForHistory[1]) мм²
			Сила от давления, F1 =  \(resultForHistory[2]) Н
			Сила среза крепежа, F2 =  \(resultForHistory[3]) Н
			Количество болтов, n =  \(resultForHistory[4]) шт.
			""",
			inputValues: ["\(D1)", "\(D2)", "\(P)", "\(d)", "\(στ)"],
			outputValues: [resultForHistory[0],resultForHistory[1],resultForHistory[2],resultForHistory[3],resultForHistory[4]])
		return historyModel
	}
	
}

extension BoltsCountCalculationCore {
	
	enum Parameters: Float, CaseIterable {
		case D1
		case D2
		case P
		case d
		case στ
	}
}

