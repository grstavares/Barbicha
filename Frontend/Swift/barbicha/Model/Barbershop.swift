//
//  Barbershop.swift
//  barbicha
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
import PlazazCore
import SipHash

class Barbershop: PlazazOrganization {

    public var uuid: String
    public var name: String?
    public var imageUrl: URL?
    public var imageData: Data?
    public var serviceTypes: [AppointmentType]
    public var barbers: [Barber]
    public var location: (Double, Double)?

    private var appointments: [Appointment]
    
    init(name: String, imageUrl: URL?, services: [AppointmentType]) {
        
        self.uuid = PlazazCoreHelpers.newUUID(for: Barbershop.self)
        self.name = name
        self.imageUrl = imageUrl
        self.serviceTypes = services
        self.appointments = []
        self.barbers = []
        
        if imageUrl != nil {
            
            AppDelegate.imageFromUrl(url: imageUrl!) { (data, error) in
                
                guard error == nil else {return}
                self.imageData = data
                self.informChange(type: .imageChanged, object: self)
                
            }
            
        }
        
    }

    public func addBarber(_ barber: Barber) -> Void {
    
        self.barbers.append(barber)
        self.informChange(type: .itemAdded, object: self)
        
    }
    
    public func removeBarber(_ barber: Barber) -> Void {
        
        var i: Int = 0
        var toBeRemoved: Int? = nil
        for item in self.barbers {
            if item == barber {toBeRemoved = i}
            i = i + 1
        }
        
        if let found = toBeRemoved {
            self.barbers.remove(at: found)
            self.informChange(type: .itemRemoved, object: self)
        }

    }
    
    public func appointments(for date: Date, with barberId: String?) -> [Appointment] {
        
        var appointmentList: [Appointment] = []
        
        let startTime:Date = self.startTime(for: date)
        let endTime:Date = self.endTime(for: date)
        let slot:TimeInterval = self.slotTime(for: date)
        
        var dateWalk:Date = startTime
        while dateWalk <  endTime {
            
            let comparationStart = dateWalk.addingTimeInterval(-10)
            let comparationEnd = dateWalk.addingTimeInterval(10)
            
            var found = self.appointments.filter {
                
                let fromBarber = barberId == nil ? true : barberId! == $0.barberUUID!
                return $0.startDate > comparationStart && $0.startDate < comparationEnd && fromBarber
                
            }
            
            let value = found.count > 0 ? found[0] : Appointment.empty(for: dateWalk, interval: slot)

            appointmentList.append(value)
            dateWalk.addTimeInterval(slot)
            
        }
        
        return appointmentList
        
    }
    
    public func schedulle(for empty: Appointment, type: AppointmentType, with barber: Barber, customer: PlazazPerson, handler: @escaping (Bool) -> ()) -> Void {
        
        let allAppointments = self.appointments(for: empty.startDate, with: barber.uuid)
        for i in 0...allAppointments.count - 1 {
            
            let existent = allAppointments[i]
            if existent == empty {
                
                let newAppointment = Appointment(time: empty.startDate, interval: type.time, type: type, barberId: barber.uuid, customerId: customer.uuid, customerName: customer.name)
                self.appointments.append(newAppointment)
                handler(true)
                return}}
        
        handler(false)
        
    }
    
    public func confirm(for date: Date, type: AppointmentType, customer: PlazazPerson, handler: @escaping (Bool) -> ()) -> Void {}
    
    public func cancel(for date: Date, type: AppointmentType, customer: PlazazPerson, handler: @escaping (Bool) -> ()) -> Void {}
    
    public func move(for date: Date, type: AppointmentType, customer: PlazazPerson, handler: @escaping (Bool) -> ()) -> Void {}
    
    private func informChange(type: CollectionObservableEvent, object: Barbershop) -> Void {}
    
}

extension Barbershop: SipHashable {
    
    public func appendHashes(to hasher: inout SipHasher) {
        hasher.append(self.uuid)
        hasher.append(self.name)
        hasher.append(self.imageUrl)
        for item in self.serviceTypes.sorted(by: {$0.index < $1.index}) {hasher.append(item)}
        for item in self.barbers.sorted(by: {$0.uuid < $1.uuid}) {hasher.append(item)}
    }
    
    public static func == (lhs: Barbershop, rhs: Barbershop) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    
}

extension Barbershop: ExposableAsCollection {
    
    var image: Data? {return self.imageData}
    var mainLabel: String {return self.name ?? "EmptyName"}
    var detail: String? {return "Details"}
    var moreDetail: String? {return "MoreDetails"}
    var itens: [Exposable] {return self.barbers}
    
    var cellImage: Data? {return self.image}
    var cellLabel: String? {return self.mainLabel}
    var reference: Exposable {return self}

    var observableEvents: [Notification.Name] {
        
        let collectionEvents = [CollectionObservableEvent.collectionCleared.name, CollectionObservableEvent.itemAdded.name, CollectionObservableEvent.itemRemoved.name, CollectionObservableEvent.itemChangedOrder.name]
        let collectionItensEvents = [CollectionItemObservableEvent.itemRemoved.name, CollectionItemObservableEvent.itemUpdated.name]
        return collectionEvents + collectionItensEvents
        
    }
    
}
