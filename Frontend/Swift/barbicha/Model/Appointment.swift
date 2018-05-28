//
//  Appointment.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 17/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
import PlazazCore
import SipHash

class Appointment: Equatable, Codable {
    
    let uuid: String
    var startDate: Date
    var interval: TimeInterval
    var serviceType: Int
    var status: Status
    var barberUUID: String?
    var customerUUID: String?
    var customerName: String?

    var isEmpty: Bool {return self.serviceType == AppointmentType.kEmptyTypeIndex}
    var isUnavailable: Bool {return self.serviceType == AppointmentType.kUnavailableTypeIndex}
    
    init(uuid:String, time: Date, interval: TimeInterval, type: AppointmentType, status: Status, barberId: String?, customerId: String?, customerName: String?) {
        
        self.uuid = uuid
        self.startDate = time
        self.interval = interval
        self.serviceType = type.index
        self.status = status
        self.barberUUID = barberId
        self.customerUUID = customerId
        self.customerName = customerName
        
    }
    
    convenience init(time: Date, interval: TimeInterval, type: AppointmentType, status: Status, barberId: String?, customerId: String?, customerName: String?) {
        
        let uuid = PlazazCoreHelpers.newUUID(for: Appointment.self)
        self.init(uuid: uuid, time: time, interval: interval, type: type, status: status, barberId: barberId, customerId: customerId, customerName: customerName)
        
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let _uuid = try values.decode(String.self, forKey: .uuid)
        let _date = try values.decode(Date.self, forKey: .startDate)
        let _interval = try values.decode(Int.self, forKey: .interval)
        let _type = try values.decode(Int.self, forKey: .serviceType)
        let _status = try values.decode(String.self, forKey: .status)
        let _barber = try values.decode(String.self, forKey: .barberUUID)
        let _custUUID = try values.decode(String.self, forKey: .customerUUID)
        let _custName = try values.decode(String.self, forKey: .customerUUID)
        
        self.uuid = _uuid
        self.startDate = _date
        self.interval = Double(_interval)
        self.barberUUID = _barber
        self.serviceType = _type
        self.status = Appointment.Status(rawValue: _status)!
        self.customerUUID = _custUUID
        self.customerName = _custName
        
    }
    
    public func updateValues(with newValues: Appointment) -> Void {
        
        var events: Set<ObservableEvent> = []
        if self.startDate != newValues.startDate {self.startDate = newValues.startDate; events.insert(ObservableEvent.dateUpdated)}
        if self.interval != newValues.interval {self.interval = newValues.interval; events.insert(ObservableEvent.dateUpdated)}
        if self.barberUUID != newValues.barberUUID {self.barberUUID = newValues.barberUUID; events.insert(ObservableEvent.infoUpdated)}
        if self.serviceType != newValues.serviceType {self.serviceType = newValues.serviceType; events.insert(ObservableEvent.infoUpdated)}
        if self.status != newValues.status {self.status = newValues.status; events.insert(ObservableEvent.statusUpdated)}
        if self.customerUUID != newValues.customerUUID {self.customerUUID = newValues.customerUUID; events.insert(ObservableEvent.infoUpdated)}
        if self.customerName != newValues.customerName {self.customerName = newValues.customerName; events.insert(ObservableEvent.infoUpdated)}
        
        events.forEach { self.signalChange(event: $0) }
        
    }
    
    public static func empty(for dateTime: Date, interval: TimeInterval) -> Appointment {
        let emptyApp: Appointment = Appointment(time: dateTime, interval: interval, type: .empty, status: .empty, barberId: nil, customerId: nil, customerName: nil)
        return emptyApp
    }
    
    public static func unavailable(for dateTime: Date, interval: TimeInterval) -> Appointment {
        let unavailableApp: Appointment = Appointment(time: dateTime, interval: interval, type: .unavailable, status: .unavailable, barberId: nil, customerId: nil, customerName: nil)
        return unavailableApp
    }
    
    public enum Status: String, Codable { case requested, cancelled, confirmed, executed, evaluated, empty, unavailable}
    public enum CodingKeys: CodingKey {case uuid, startDate, interval, serviceType, status, barberUUID, customerUUID, customerName }
    
}

extension Appointment {
    
    public var asDict: [String:Any] {
    
        var dict:[String:Any]  = [:]
        dict[CodingKeys.startDate.stringValue] = self.startDate
        dict[CodingKeys.interval.stringValue] = self.interval
        dict[CodingKeys.serviceType.stringValue] = self.serviceType
        dict[CodingKeys.status.stringValue] = self.status.rawValue
        dict[CodingKeys.barberUUID.stringValue] = self.barberUUID
        dict[CodingKeys.customerUUID.stringValue] = self.customerUUID
        dict[CodingKeys.customerName.stringValue] = self.customerName
        return dict
        
    }
    
}

extension Appointment: CustomStringConvertible {
    
    var description: String {
        
        let begin = AppUtilities.shared.formatDate(self.startDate, style: .humanDateTime)!
        return "Appointment: [\(begin) - \(self.interval)] \(self.serviceType) for \(self.customerName ?? "NoName") with \(self.barberUUID ?? "NoBarber")"
        
    }
    
}

extension Appointment: SipHashable {
    
    public func appendHashes(to hasher: inout SipHasher) {
        hasher.append(self.uuid)
        hasher.append(self.startDate)
        hasher.append(self.interval)
        hasher.append(self.serviceType)
        hasher.append(self.barberUUID)
        hasher.append(self.customerUUID)
        hasher.append(self.customerName)
    }
    
    public static func == (lhs: Appointment, rhs: Appointment) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

}

extension Appointment: ExposableAsAppointment {

    var detail: String? {return self.customerName}

}

