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

        let allEmpty = list.filter { $0.isEmpty }
        let allUnavailable = list.filter { $0.isUnavailable }
        XCTAssert(list.count == allEmpty.count + allUnavailable.count)
        
    }
    
    func testSchedulleAppointment() {

        guard let sut = sut else {XCTFail("SUT not initialized!"); return}
        
        let list = sut.appointments(for: self.normalDate, with: nil)
        XCTAssert(list.count > 0)

        let selectForSchedulle = list[10]
        let allEmpty = list.filter { $0.isEmpty }
        let allUnavailable = list.filter { $0.isUnavailable }
        XCTAssert(list.count == allEmpty.count + allUnavailable.count)

        debugPrint("Will check for \(selectForSchedulle.startDate) in:")
        list.forEach {debugPrint("Appointment -> \($0.startDate) with \($0.interval), \($0.serviceType.label)")}
        
        let mockServiceType = sut.serviceTypes[0]
        let mockBarber = sut.barbers[0]
        let mockCustomer = sut.barbers[1]
        
        let expectSuccess = expectation(description: "Appointment Schedulled")
        sut.schedulle(for: selectForSchedulle, type: mockServiceType, with: mockBarber, customer: mockCustomer) { (result) in if result {expectSuccess.fulfill()}}
        waitForExpectations(timeout: 1.0, handler: nil)
        
        let newList = sut.appointments(for: self.normalDate, with: nil)
        let newEmpty = newList.filter { $0.isEmpty }
        let newUnavailable = newList.filter { $0.isUnavailable }
        let newSchedulled = newList.filter { !$0.isUnavailable && !$0.isEmpty}
        XCTAssert(list.count == newEmpty.count + newUnavailable.count + newSchedulled.count)
        XCTAssert(newSchedulled.count > 0)
        
    }
    
    private var normalDate: Date {return Date()}
    private var weekendDate: Date {return Date()}
    private var offDate: Date {return Date()}
    
}
