//
//  Dimensions.swift
//  calc
//
//  Created by Nesiolovsky on 20.12.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//

import Foundation

final class Dimensions {
	
	let stressAndPressureArray = [
		StressAndPressure.MPa,
		StressAndPressure.Pa,
		StressAndPressure.psi,
		StressAndPressure.bar
	]
	let diameterArray = [
		Diameter.mm,
		Diameter.inch,
		Diameter.m,
	]
}
	
extension Dimensions {
	enum StressAndPressure: String, CustomStringConvertible, Equatable{
        static func == (lhs: StressAndPressure, rhs: StressAndPressure) -> Bool {
            switch (lhs, rhs) {
            case (.MPa, .MPa):
            return true
            case ( .Pa, .Pa):
            return true
            case ( .psi, .psi):
            return true
            case ( .bar, .bar):
            return true
            default:
            return false
            }
        }
        case MPa = "МПа"
		case Pa = "Па"
		case psi = "psi"
		case bar = "атм"
		var description: String { rawValue }
	}
}
	
extension Dimensions {
	enum Diameter: String, CustomStringConvertible, Equatable {
        static func == (lhs: Diameter, rhs: Diameter) -> Bool {
            switch (lhs, rhs) {
            case (.mm, .mm):
            return true
            case ( .inch, .inch):
            return true
            case ( .m, .m):
            return true
            default:
            return false
            }
        }
		case mm = "мм"
		case inch = "дюйм"
		case m = "м"
		var description: String { rawValue }
	}
}
