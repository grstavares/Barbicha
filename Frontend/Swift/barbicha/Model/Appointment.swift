//
//  Appointment.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 17/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation

public class Appointment {
    
    var startDate: Date
    var interval: TimeInterval
    var serviceType: AppointmentType
    var barberUUID: String?
    var customerUUID: String?
    var customerName: String?

    init(time: Date, interval: TimeInterval, type: AppointmentType, barberId: String?, customerId: String?, customerName: String?) {
        
        self.startDate = time
        self.interval = interval
        self.serviceType = type
        self.barberUUID = barberId
        self.customerUUID = customerId
        self.customerName = customerName
        
    }
    
    enum AppointmentType {case barba, cabela, barbaCabelo, empty, unavailable}
    
    public static func empty(for dateTime: Date, interval: TimeInterval) -> Appointment {
        let emptyApp: Appointment = Appointment.init(time: dateTime, interval: interval, type: .empty, barberId: nil, customerId: nil, customerName: nil)
        return emptyApp
    }
    
    public static func unavailable(for dateTime: Date, interval: TimeInterval) -> Appointment {
        let unavailableApp: Appointment = Appointment.init(time: dateTime, interval: interval, type: .unavailable, barberId: nil, customerId: nil, customerName: nil)
        return unavailableApp
    }
    
}


