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
  enum StressAndPressure: String, CustomStringConvertible {
    case MPa = "МПа"
    case Pa = "Па"
    case psi = "psi"
    case bar = "атм"
    var description: String { rawValue }
    var coefficient: Double {
      switch self {
      case .MPa:
        return 1
      case .Pa:
        return 0.000001
      case .psi:
        return 145.038
      case .bar:
        return 9.869
      }
    }
  }
}

extension Dimensions {
  enum Diameter: String, CustomStringConvertible {
    case mm = "мм"
    case inch = "дюйм"
    case m = "м"
    var description: String { rawValue }
    var coefficient: Double {
      switch self {
      case .mm:
        return 1
      case .inch:
        return 0.03937
      case .m:
        return 0.001
      }
    }
  }
}


