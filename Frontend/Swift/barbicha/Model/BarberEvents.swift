//
//  BarberEvents.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 23/05/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
extension Barber {
    
    public enum ObservableEvent: String {
        
        case barberUpdated
        case barberImageUpdated
        
        var notificationName: Notification.Name { return Notification.Name(rawValue: self.rawValue) }
        
    }
    
    public func signalChange(event: ObservableEvent) -> Void {
        
        let notification = Notification.init(name: event.notificationName, object: self, userInfo: nil)
        NotificationCenter.default.post(notification)
        
    }
    
}
