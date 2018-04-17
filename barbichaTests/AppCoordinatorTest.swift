//
//  AppCoordinatorTest.swift
//  barbichaTests
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import XCTest
@testable import barbicha

class AppCoordinatorTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMockInitialization() {
        
        let sut = AppCoordinator.shared
        let mock = sut.mockBarbershop
        XCTAssertNotNil(mock)
        XCTAssert(mock.itens.count > 0)
        
        for item in mock.itens {XCTAssertNotNil(item.cellImage)}
        
    }
    
}
