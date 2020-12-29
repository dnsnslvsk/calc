//
//  calcTests.swift
//  calcTests
//
//  Created by Денис Несиоловский on 27.12.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//

import XCTest
@testable import calc

class СalcTests: XCTestCase {
    
    var viewController: ViewController!
    var cell: Cell!
    
    override func setUpWithError() throws {
        super.setUp()
        viewController = ViewController()
        cell = Cell()
    }

    override func tearDownWithError() throws {
        viewController = nil
        cell = nil
        super.tearDown()
    }
    
    func testButtonHaveAction() {
        let button = cell.dimensionButton
        
        cell.configureDimensionButton(button)
        
        guard let actions = button.actions(forTarget: cell, forControlEvent: .touchUpInside) else {
            XCTFail()
            return
        }
        let expectedActions = ["dimensionButtonAction:"]
        XCTAssertEqual(actions, expectedActions, "A button have no actions")
    }
    
    func testIsElementOnContentView() {
        let button = cell.dimensionButton
        
        cell.configureDimensionButton(button)
     
        guard let view = button.superview else {
            XCTFail()
            return
        }
        let expectedView = cell.contentView
        XCTAssertEqual(view, expectedView, "An element not on correct view")
    }
    
}
