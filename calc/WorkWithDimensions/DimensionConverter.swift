//
//  DimensionConverter.swift
//  calc
//
//  Created by Денис Несиоловский on 24.09.2021.
//  Copyright © 2021 Nesiolovsky. All rights reserved.
//

import Foundation

final class DimensionConverter {
  
  func convertValues(model: CellModel, validatedDimension: Measurement<Dimension>?) -> String {
    guard let unwrappedValidatedDimension = validatedDimension else { return "" }
    var convertedValue: Measurement<Dimension>?
    switch unwrappedValidatedDimension.unit {
    case is UnitPressure:
      switch model.currentDimension.description {
      case "МПа":
        convertedValue = unwrappedValidatedDimension.converted(to: UnitPressure.megapascals)
      case "Па":
        convertedValue = unwrappedValidatedDimension.converted(to: UnitPressure.newtonsPerMetersSquared)
      case "psi":
        convertedValue = unwrappedValidatedDimension.converted(to: UnitPressure.poundsForcePerSquareInch)
      case "атм":
        convertedValue = unwrappedValidatedDimension.converted(to: UnitPressure.bars)
      default:
        return ""
      }
    case is UnitLength:
      switch model.currentDimension.description {
      case "мм":
        convertedValue = unwrappedValidatedDimension.converted(to: UnitLength.millimeters)
      case "дюйм":
        convertedValue = unwrappedValidatedDimension.converted(to: UnitLength.inches)
      case "м":
        convertedValue = unwrappedValidatedDimension.converted(to: UnitLength.meters)
      default:
        return ""
      }
    default:
      return ""
    }
    return roundValue(convertedValue)
  }
  
  func roundValue (_ convertedValue: Measurement<Dimension>?) -> String {
    guard let unwrappedConvertedValue = convertedValue?.value else { return "" }
    let roundedConvertedValue = String(round(100*unwrappedConvertedValue)/100)
    return roundedConvertedValue
  }
  
}
