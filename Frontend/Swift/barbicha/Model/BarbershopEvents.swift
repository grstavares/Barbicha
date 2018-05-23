//
//  BarbershopEvents.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 21/05/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
extension Barbershop {

    public enum ObservableEvent: String {

        case shopUpdated
        case imageUpdated
        case barberAdded
        case barberUpdated
        case barberRemoved
        case appointmentSchedulled
        case appointmentConfirmed
        case appointmentCanceled
        case appointmentChanged

        var notificationName: Notification.Name { return Notification.Name(rawValue: self.rawValue) }
        
    }
    
//    public struct ObservableEvent: OptionSet, Hashable {
//
//        let rawValue: Int
//
//        static let shopUpdated = ObservableEvent(rawValue: 1)
//        static let imageUpdated = ObservableEvent(rawValue: 2)
//        static let barberAdded = ObservableEvent(rawValue: 4)
//        static let barberUpdated = ObservableEvent(rawValue: 8)
//        static let barberRemoved = ObservableEvent(rawValue: 16)
//        static let appointmentSchedulled = ObservableEvent(rawValue: 32)
//        static let appointmentConfirmed = ObservableEvent(rawValue: 64)
//        static let appointmentCanceled = ObservableEvent(rawValue: 128)
//        static let appointmentChanged = ObservableEvent(rawValue: 512)
//
//        public var hashValue: Int {return self.rawValue}
//
//    }
 
    public func signalChange(event: ObservableEvent) -> Void {
        
        let notification = Notification.init(name: event.notificationName, object: self, userInfo: nil)
        NotificationCenter.default.post(notification)
        
    }

}
