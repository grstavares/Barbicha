//
//  Appointment.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 17/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
import SipHash

class Appointment {
    
    var startDate: Date
    var interval: TimeInterval
    var serviceType: AppointmentType
    var barberUUID: String?
    var customerUUID: String?
    var customerName: String?

    var isEmpty: Bool {return self.serviceType == AppointmentType.empty}
    var isUnavailable: Bool {return self.serviceType == AppointmentType.unavailable}
    
    init(time: Date, interval: TimeInterval, type: AppointmentType, barberId: String?, customerId: String?, customerName: String?) {
        
        self.startDate = time
        self.interval = interval
        self.serviceType = type
        self.barberUUID = barberId
        self.customerUUID = customerId
        self.customerName = customerName
        
    }
    
    public static func empty(for dateTime: Date, interval: TimeInterval) -> Appointment {
        let emptyApp: Appointment = Appointment.init(time: dateTime, interval: interval, type: .empty, barberId: nil, customerId: nil, customerName: nil)
        return emptyApp
    }
    
    public static func unavailable(for dateTime: Date, interval: TimeInterval) -> Appointment {
        let unavailableApp: Appointment = Appointment.init(time: dateTime, interval: interval, type: .unavailable, barberId: nil, customerId: nil, customerName: nil)
        return unavailableApp
    }
    
}

extension Appointment: CustomStringConvertible {
    
    var description: String {
        
        let begin = AppUtilities.shared.formatDate(self.startDate, style: .humanDateTime)!
        return "Appointment: [\(begin) - \(self.interval)] \(self.serviceType.label) for \(self.customerName ?? "NoName") with \(self.barberUUID ?? "NoBarber")"
        
    }
    
}

extension Appointment: SipHashable {
    
    public func appendHashes(to hasher: inout SipHasher) {
        hasher.append(self.startDate)
        hasher.append(self.interval)
        hasher.append(self.serviceType.label)
        hasher.append(self.barberUUID)
        hasher.append(self.customerUUID)
        hasher.append(self.customerName)
    }
    
    public static func == (lhs: Appointment, rhs: Appointment) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    
    
    
}


