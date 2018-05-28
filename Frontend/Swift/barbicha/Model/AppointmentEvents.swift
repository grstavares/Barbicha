//
//  AppointmentEvents.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 24/05/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
extension Appointment {
    
    public enum ObservableEvent: String {
        
        case statusUpdated
        case dateUpdated
        case infoUpdated
        
        var notificationName: Notification.Name { return Notification.Name(rawValue: self.rawValue) }
        
    }
    
    public func signalChange(event: ObservableEvent) -> Void {
        
        let notification = Notification.init(name: event.notificationName, object: self, userInfo: nil)
        NotificationCenter.default.post(notification)
        
    }
    
}
