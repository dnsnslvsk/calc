//
//  BoltsContCalcCore.swift
//  calc
//
//  Created by Nesiolovsky on 10.12.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//

import Foundation

class BoltsContCalcCore {

    enum Parameters: Float, CaseIterable {
        case D1
        case D2
        case P
        case d
        case στ
    }
    
    let D1: Float
    let D2: Float
    let P: Float
    let d: Float
    let στ: Float
    
    internal init(D1: Float, D2: Float, P: Float, d: Float, στ: Float) {
        self.D1 = D1
        self.D2 = D2
        self.P = P
        self.d = d
        self.στ = στ
    }

    var S1: Float!
    var S2: Float!
    var F1: Float!
    var F2: Float!
    
    func calculate() -> Float {
        self.S1 = Float.pi * (D1*D1/4 - D2*D2/4)
        self.S2 = Float.pi * d * d / 4
        self.F1 = S1 * P
        self.F2 = στ * S2
        let n = round(F1/F2)
        return n
    }
    
    func getFormattedResult() -> String {
        let r = calculate()
        let result = """
        Площадь под давлением \(S1) мм^2
        Площадь крепежного элемента \(S2) мм^2
        Сила от давления \(F1) Н
        Сила для среза одного крепежного элемента \(F2) Н
        Кол-во элементов для работы конструкции \(r) шт.
        """
        return result
    }
}
