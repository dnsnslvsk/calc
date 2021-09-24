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
			parameterValue: "1000",
      parameterType: ParameterType.input,
      isExpanded: .notExpanded),
		CellModel(
			parameterName: "Меньший диаметер, D2",
			currentDimension: dimensions.diameterArray[0],
			avaliableDimensions: dimensions.diameterArray,
			parameterValue: "100",
      parameterType: ParameterType.input,
      isExpanded: .notExpanded),
		CellModel(
			parameterName: "Давление, P",
			currentDimension: dimensions.stressAndPressureArray[0],
			avaliableDimensions: dimensions.stressAndPressureArray,
			parameterValue: "100",
      parameterType: ParameterType.input,
      isExpanded: .notExpanded),
		CellModel(
			parameterName: "Диаметр срезного элемента, d",
			currentDimension: dimensions.diameterArray[0],
			avaliableDimensions: dimensions.diameterArray,
			parameterValue: "10",
      parameterType: ParameterType.input,
      isExpanded: .notExpanded),
		CellModel(
			parameterName: "Доп. напряжение на срез, [σ]τ",
			currentDimension: dimensions.stressAndPressureArray[0],
			avaliableDimensions: dimensions.stressAndPressureArray,
			parameterValue: "200",
      parameterType: ParameterType.input,
      isExpanded: .notExpanded),
	]
	lazy var outputModels = [
		CellModel(
			parameterName: "Площадь под давлением, S1",
			currentDimension: dimensions.diameterArray[0],
			avaliableDimensions: dimensions.diameterArray,
			parameterValue: "",
      parameterType: ParameterType.output,
      isExpanded: .notExpanded),
		CellModel(
			parameterName: "Сечение крепежа, S2",
			currentDimension: dimensions.diameterArray[0],
			avaliableDimensions: dimensions.diameterArray,
			parameterValue: "",
      parameterType: ParameterType.output,
      isExpanded: .notExpanded),
		CellModel(
			parameterName: "Сила от давления, F1",
			currentDimension: dimensions.stressAndPressureArray[0],
			avaliableDimensions: dimensions.stressAndPressureArray,
			parameterValue: "",
      parameterType: ParameterType.output,
      isExpanded: .notExpanded),
		CellModel(
			parameterName: "Сила среза крепежа, F2",
			currentDimension: dimensions.stressAndPressureArray[0],
			avaliableDimensions: dimensions.stressAndPressureArray,
			parameterValue: "",
      parameterType: ParameterType.output,
      isExpanded: .notExpanded),
		CellModel(
			parameterName: "Количество болтов, n",
			currentDimension: dimensions.stressAndPressureArray[0],
			avaliableDimensions: dimensions.stressAndPressureArray,
			parameterValue: "",
      parameterType: ParameterType.output,
      isExpanded: .notExpandable),
	]
}

final class BoltsCountCalculationCore {
	
	// MARK: - Internal properties

	let D1: Double
	let D2: Double
	let P: Double
	let d: Double
	let στ: Double
	var result: [String] = []
  
	var S1: Double = 0
	var S2: Double = 0
	var F1: Double = 0
	var F2: Double = 0
	var n: Double = 0
	var resultForHistory: [String] = []
	
	// MARK: - Internal methods

	func calculate() -> [Double] {
		S1 = round(Double.pi * ((D1*D1)/4 - (D2*D2)/4))
		S2 = round(Double.pi * d * d / 4)
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
			Площадь под давлением, S1 =  \(S1) мм²
			Сечение крепежа, S2 =  \(S2) мм²
			Сила от давления, F1 =  \(F1) Н
			Сила среза крепежа, F2 =  \(F2) Н
			Количество болтов, n =  \(n) шт.
			""",
			inputValues: ["\(D1)", "\(D2)", "\(P)", "\(d)", "\(στ)"],
			outputValues: ["\(S1)", "\(S2)", "\(F1)", "\(F2)", "\(n)"])
		return historyModel
	}
	
	// MARK: - Initialization

	internal init(inputValues: [Double]) {
    self.D1 = inputValues[0]
		self.D2 = inputValues[1]
		self.P = inputValues[2]
		self.d = inputValues[3]
		self.στ = inputValues[4]
	}
}



extension BoltsCountCalculationCore {
	
	enum Parameters: Double, CaseIterable {
    case D1
		case D2
		case P
		case d
		case στ
	}
}

