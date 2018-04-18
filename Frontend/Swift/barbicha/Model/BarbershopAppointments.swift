//
//  BarbershopAppointments.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 17/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
extension Barbershop {
    
    public func dayStart(for date: Date) -> Date {
        
        var now = Calendar.current.dateComponents([.calendar, .timeZone, .day, .month, .year], from: Date())
        now.setValue(6, for: .hour)
        now.setValue(0, for: .minute)
        now.setValue(0, for: .second)
        return now.date!
        
    }
    
    public func dayEnd(for date: Date) -> Date {
        
        var now = Calendar.current.dateComponents([.calendar, .timeZone, .day, .month, .year], from: Date())
        now.setValue(23, for: .hour)
        now.setValue(0, for: .minute)
        now.setValue(0, for: .second)
        return now.date!
        
    }
    
    public func startTime(for date: Date) -> Date {
        
        var now = Calendar.current.dateComponents([.calendar, .timeZone, .day, .month, .year], from: Date())
        now.setValue(9, for: .hour)
        now.setValue(30, for: .minute)
        now.setValue(0, for: .second)
        return now.date!
        
    }
    
    public func endTime(for date: Date) -> Date {
        
        var now = Calendar.current.dateComponents([.calendar, .timeZone, .day, .month, .year], from: Date())
        now.setValue(21, for: .hour)
        now.setValue(0, for: .minute)
        now.setValue(0, for: .second)
        return now.date!
        
    }
    
    public func slotTime(for date: Date) -> TimeInterval {return TimeInterval(30 * 60)}
    
    public func appointments(for date: Date, with barberId: String?) -> [Appointment] {
        
        var appointmentList: [Appointment] = []
        
        let startTime = self.startTime(for: date)
        let endTime = self.endTime(for: date)
        let slot = self.slotTime(for: date)
        
        var dateWalk = self.dayStart(for: date)
        let finalHour = self.dayEnd(for: date)
        while dateWalk <  finalHour {
            
            var value: Appointment?
            if dateWalk < startTime && dateWalk > endTime {
                
                value = Appointment.unavailable(for: dateWalk, interval: slot)
            
            } else { value = Appointment.empty(for: dateWalk, interval: slot)}
            
            if value != nil {appointmentList.append(value!)}
            dateWalk.addTimeInterval(slot)

        }
        
        return appointmentList
        
    }
    
}
