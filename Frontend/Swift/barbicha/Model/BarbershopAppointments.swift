//
//  BarbershopAppointments.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 17/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
import PlazazCore

extension Barbershop {
    
    public func dayStart(for date: Date) -> Date {
        
        var now = Calendar.current.dateComponents([.calendar, .timeZone, .day, .month, .year], from: date)
        now.setValue(6, for: .hour)
        now.setValue(0, for: .minute)
        now.setValue(0, for: .second)
        return now.date!
        
    }
    
    public func dayEnd(for date: Date) -> Date {
        
        var now = Calendar.current.dateComponents([.calendar, .timeZone, .day, .month, .year], from: date)
        now.setValue(23, for: .hour)
        now.setValue(0, for: .minute)
        now.setValue(0, for: .second)
        return now.date!
        
    }
    
    public func startTime(for date: Date) -> Date {
        
        var now = Calendar.current.dateComponents([.calendar, .timeZone, .day, .month, .year], from: date)
        now.setValue(9, for: .hour)
        now.setValue(30, for: .minute)
        now.setValue(0, for: .second)
        return now.date!
        
    }
    
    public func endTime(for date: Date) -> Date {
        
        var now = Calendar.current.dateComponents([.calendar, .timeZone, .day, .month, .year], from: date)
        now.setValue(21, for: .hour)
        now.setValue(0, for: .minute)
        now.setValue(0, for: .second)
        return now.date!
        
    }
    
    public func slotTime(for date: Date) -> TimeInterval {return TimeInterval(30 * 60)}
    


}
