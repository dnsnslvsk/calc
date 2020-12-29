//
//  BoltsContCalcCore.swift
//  calc
//
//  Created by Nesiolovsky on 10.12.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//

import Foundation

final class BoltsCountDataSource {
	
	// MARK: - Internal properties

	let dimensions = Dimensions()
	lazy var inputModels = [
		CellModel(
			parameterName: "Больший диаметр, D1",
			currentDimension: dimensions.diameterArray[0],
			avaliableDimensions: dimensions.diameterArray,
			parameterValue: "",
            parameterType: ParameterType.input),
		CellModel(
			parameterName: "Меньший диаметер, D2",
			currentDimension: dimensions.diameterArray[0],
			avaliableDimensions: dimensions.diameterArray,
			parameterValue: "",
            parameterType: ParameterType.input),
		CellModel(
			parameterName: "Давление, P",
			currentDimension: dimensions.stressAndPressureArray[0],
			avaliableDimensions: dimensions.stressAndPressureArray,
			parameterValue: "",
            parameterType: ParameterType.input),
		CellModel(
			parameterName: "Диаметр срезного элемента, d",
			currentDimension: dimensions.diameterArray[0],
			avaliableDimensions: dimensions.diameterArray,
			parameterValue: "",
            parameterType: ParameterType.input),
		CellModel(
			parameterName: "Доп. напряжение на срез, [σ]τ",
			currentDimension: dimensions.stressAndPressureArray[0],
			avaliableDimensions: dimensions.stressAndPressureArray,
			parameterValue: "",
            parameterType: ParameterType.input),
	]
	lazy var outputModels = [
		CellModel(
			parameterName: "Площадь под давлением, S1",
			currentDimension: dimensions.diameterArray[0],
			avaliableDimensions: dimensions.diameterArray,
			parameterValue: "",
            parameterType: ParameterType.output),
		CellModel(
			parameterName: "Сечение крепежа, S2",
			currentDimension: dimensions.diameterArray[0],
			avaliableDimensions: dimensions.diameterArray,
			parameterValue: "",
            parameterType: ParameterType.output),
		CellModel(
			parameterName: "Сила от давления, F1",
			currentDimension: dimensions.stressAndPressureArray[0],
			avaliableDimensions: dimensions.stressAndPressureArray,
			parameterValue: "",
            parameterType: ParameterType.output),
		CellModel(
			parameterName: "Сила среза крепежа, F2",
			currentDimension: dimensions.stressAndPressureArray[0],
			avaliableDimensions: dimensions.stressAndPressureArray,
			parameterValue: "",
            parameterType: ParameterType.output),
		CellModel(
			parameterName: "Количество болтов, n",
			currentDimension: dimensions.stressAndPressureArray[0],
			avaliableDimensions: dimensions.stressAndPressureArray,
			parameterValue: "",
            parameterType: ParameterType.output),
	]
}

final class BoltsCountCalculationCore {
	
	// MARK: - Internal properties

	let D1: Float
	let D2: Float
	let P: Float
	let d: Float
	let στ: Float
	var result: [String] = []
	var S1: Float = 0
	var S2: Float = 0
	var F1: Float = 0
	var F2: Float = 0
	var n: Float = 0
	var resultForHistory: [String] = []
	
	// MARK: - Internal methods

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
	
	// MARK: - Initialization

	internal init(D1: Float, D2: Float, P: Float, d: Float, στ: Float) {
		self.D1 = D1
		self.D2 = D2
		self.P = P
		self.d = d
		self.στ = στ
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

