//
//  BarbershopAppointmentsTest.swift
//  BarbichaTests
//
//  Created by Gustavo Tavares on 17/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import XCTest
@testable import Barbicha

class BarbershopAppointmentsTest: XCTestCase {

    var sut: Barbershop?
    
    override func setUp() {
        super.setUp()
        
        let coordinator = AppCoordinator.shared
        sut = coordinator.brotherhood
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetListofAppointmentsForDate() {
        
        guard let sut = sut else {XCTFail("SUT not initialized!"); return}
        
        let list = sut.appointments(for: self.normalDate, with: nil)
        XCTAssert(list.count > 0)
        
        debugPrint("Total of appointments: \(list.count)")
        
    }
    
    private var normalDate: Date {return Date()}
    private var weekendDate: Date {return Date()}
    private var offDate: Date {return Date()}
    
}
