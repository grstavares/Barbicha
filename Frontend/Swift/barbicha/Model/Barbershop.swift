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
            
        } else {self.imageData = AppUtilities.shared.fallbackFromCache(name: uuid, extension: defaultImageFormat)}
        
    }

    public func updateFromCloud(dict: Dictionary<String, Any>) -> Void {
        
        let _name = dict["name"] as? String
        let _imageUrl = dict["imageUrl"] as? String
        let _latitude = dict["latitude"] as? Double
        let _longitude = dict["longitude"] as? Double
        
        var changed = false
        if self.name != _name {self.name = _name; changed = true}
        if self.latitude != _latitude {self.latitude = _latitude; changed = true}
        if self.longitude != _longitude {self.longitude = _longitude; changed = true}
        if self.imageUrl?.absoluteString != _imageUrl {
            
            let newUrl:URL? = _imageUrl == nil ? nil : URL(string: _imageUrl!)
            self.imageUrl = newUrl
            
        }
        
        if changed {self.signalChange(event: .shopUpdated)}
        
    }
    
    public func updateBarbersFromCloud(barbers fromWeb: [Barber]) -> Void {

        var changed: Bool = false
        
        let oldUUIDs:Set<String> = Set(self.barbers.compactMap { $0.uuid })
        let newUUIDs:Set<String> = Set(fromWeb.compactMap { $0.uuid })
        
        let toBeRemoved = oldUUIDs.subtracting(newUUIDs)
        if toBeRemoved.count > 0 {changed = true}
        
        let toBeAdded = newUUIDs.subtracting(oldUUIDs)
        if toBeAdded.count > 0 {changed = true}
        
        let toBeUpdated = oldUUIDs.intersection(newUUIDs)
        
        var updatedArray: [Barber] = []
        for id in toBeUpdated {
            
            let old = self.barbers.filter({ id == $0.uuid }).first
            let new = fromWeb.filter({ id == $0.uuid }).first
            
            if old != nil {
                
                if new != nil {
                    if old != new {
                        changed = true
                        old?.updateValues(with: new!)}}
                
                updatedArray.append(old!)
                
            }

        }
        
        let newArray = fromWeb.filter { toBeAdded.contains($0.uuid) }
        
        if changed {
            self.barbers = newArray + updatedArray
            self.signalChange(event: .barberListUpdated)
        }

    }
    
    public func updateServicesFromCloud(services: [AppointmentType]) -> Void {
        
        self.serviceTypes = services
        
    }
    
    public func updateAppointmentsFromCloud(appointments fromWeb: [Appointment]) -> Void {

        var changed: Bool = false
        
        let oldUUIDs:Set<String> = Set(self.appointments.compactMap { $0.uuid })
        let newUUIDs:Set<String> = Set(fromWeb.compactMap { $0.uuid })
        
        let toBeRemoved = oldUUIDs.subtracting(newUUIDs)
        if toBeRemoved.count > 0 {changed = true}
        
        let toBeAdded = newUUIDs.subtracting(oldUUIDs)
        if toBeAdded.count > 0 {changed = true}
        
        let toBeUpdated = oldUUIDs.intersection(newUUIDs)
        
        var updatedArray: [Appointment] = []
        for id in toBeUpdated {
            
            let old = self.appointments.filter({ id == $0.uuid }).first
            let new = fromWeb.filter({ id == $0.uuid }).first
            
            if old != nil {
                
                if new != nil {
                    if old != new {
                        changed = true
                        old?.updateValues(with: new!)}}
                
                updatedArray.append(old!)
                
            }
            
        }
        
        let newArray = fromWeb.filter { toBeAdded.contains($0.uuid) }
        
        if changed {
            self.appointments = newArray + updatedArray
            self.signalChange(event: .appointmentListUpdated)
        }
        
        
        
    }

    public func addBarber(_ barber: Barber) -> Void {
    
        self.barbers.append(barber)
        self.signalChange(event: .barberListUpdated)
        
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
            self.signalChange(event: .barberListUpdated)
        }

    }
    
    public func appointments(for date: Date, with barberId: String?) -> [Appointment] {

        var appointmentList: [Appointment] = []
        
        let startTime:Date = self.startTime(for: date)
        let endTime:Date = self.endTime(for: date)
        let slot:Int = self.slotTime(for: date)
        
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
            dateWalk.addTimeInterval(Double(slot * 60))
            
        }
        
        return appointmentList
        
    }

    public func confirm(for date: Date, type: AppointmentType, customer: PlazazPerson, handler: @escaping (Bool) -> ()) -> Void {}
    
    public func cancel(for date: Date, type: AppointmentType, customer: PlazazPerson, handler: @escaping (Bool) -> ()) -> Void {}
    
    public func move(for date: Date, type: AppointmentType, customer: PlazazPerson, handler: @escaping (Bool) -> ()) -> Void {}
    
}
