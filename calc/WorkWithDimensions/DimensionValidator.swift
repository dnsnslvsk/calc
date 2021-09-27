//
//  DimensionValidator.swift
//  calc
//
//  Created by Денис Несиоловский on 24.09.2021.
//  Copyright © 2021 Nesiolovsky. All rights reserved.
//

import Foundation

final class DimensionValidator {
  
  // MARK: - Internal methods
  
  func didValidateDimension(model: CellModel) -> Measurement<Dimension>? {
    guard let unwrappedValue = Double(model.parameterValue) else { return nil }
    var validatedDimension: Measurement<Dimension>?
    switch model.currentDimension.description {
    case "МПа":
      validatedDimension = Measurement(value: unwrappedValue, unit: UnitPressure.megapascals)
    case "Па":
      validatedDimension = Measurement(value: unwrappedValue, unit: UnitPressure.newtonsPerMetersSquared)
    case "psi":
      validatedDimension = Measurement(value: unwrappedValue, unit: UnitPressure.poundsForcePerSquareInch)
    case "атм":
      validatedDimension = Measurement(value: unwrappedValue, unit: UnitPressure.bars)
    case "мм":
      validatedDimension = Measurement(value: unwrappedValue, unit: UnitLength.millimeters)
    case "дюйм":
      validatedDimension = Measurement(value: unwrappedValue, unit: UnitLength.inches)
    case "м":
      validatedDimension = Measurement(value: unwrappedValue, unit: UnitLength.meters)
    default: break
    }
    return validatedDimension
  }
  
}
