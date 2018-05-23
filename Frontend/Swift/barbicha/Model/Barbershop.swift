//
//  Barbershop.swift
//  barbicha
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
import PlazazCore
import FirebaseFirestore
import SipHash

class Barbershop: PlazazOrganization, Codable {

    public private (set) var uuid: String
    public var name: String?
    public var imageUrl: URL?
    public var imageData: Data?
    private var latitude: Double?
    private var longitude: Double?
    public private (set) var serviceTypes: [AppointmentType]
    public private (set) var barbers: [Barber]
    private var appointments: [Appointment]
    
    public var location: (Double, Double)? {
        
        get {return (self.latitude == nil || self.longitude == nil ? nil : (self.latitude!, self.longitude!))}
        
        set {
            
            if newValue == nil {self.latitude = nil; self.longitude = nil
            } else {self.latitude = newValue!.0; self.longitude = newValue!.1}
            
        }
    }
    
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
                self.signalChange(event: .imageUpdated)
                
            }
            
        }
        
    }

    init(firestoreDocument: DocumentSnapshot) {
        
        let data = firestoreDocument.data()
        let latitude = data["latitude"] as? Double ?? 0
        let longitude = data["longitude"] as? Double ?? 0
        
        self.uuid = firestoreDocument.documentID
        self.name = data["name"] as? String ?? "NoName"
        self.imageUrl = data["imageURL"] as? URL
        self.imageData = nil
        self.latitude = latitude
        self.longitude = longitude
        self.serviceTypes = []
        self.barbers = []
        self.appointments = []

    }
    
    public func addBarber(_ barber: Barber) -> Void {
    
        self.barbers.append(barber)
        self.signalChange(event: .barberAdded)
        
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
            self.signalChange(event: .barberRemoved)
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
                
                let newAppointment = Appointment(time: empty.startDate, interval: type.time, type: type, status: .requested, barberId: barber.uuid, customerId: customer.uuid, customerName: customer.name)
                self.appointments.append(newAppointment)
                self.signalChange(event: .appointmentSchedulled)
                handler(true)
                return}}
        
        handler(false)
        
    }
    
    public func confirm(for date: Date, type: AppointmentType, customer: PlazazPerson, handler: @escaping (Bool) -> ()) -> Void {
        
        self.signalChange(event: .appointmentConfirmed)
        
    }
    
    public func cancel(for date: Date, type: AppointmentType, customer: PlazazPerson, handler: @escaping (Bool) -> ()) -> Void {
        
        self.signalChange(event: .appointmentCanceled)
        
    }
    
    public func move(for date: Date, type: AppointmentType, customer: PlazazPerson, handler: @escaping (Bool) -> ()) -> Void {
        
        self.signalChange(event: .appointmentChanged)
        
    }
    
}

extension Barbershop: CustomStringConvertible {
    
    var description: String {
        
        let location = self.location != nil ? "(\(self.location!.0.description), \(self.location!.1.description)" : "(0,0)"
        var desc: String = "Barbershop: [\n"
        desc.append("\(self.uuid)] \(self.name ?? "NoName"), Location: (\(location)")
        self.serviceTypes.forEach {desc.append("     \($0.description)")}
        self.barbers.forEach {desc.append("     \($0.description)")}
        return desc
        
    }
    
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
