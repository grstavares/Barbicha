//
//  FirebaseProvider.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 23/05/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

class FirestoreProvider: DataProvider {

    private var firestore: Firestore?
    private var listener: ListenerRegistration?
    private var barbershop: Barbershop
    private var basePath: String {return "barbershops/" +  barbershop.uuid}
    private let personsPath:String = "persons/"
    
    private let kPathBarbers = "/barbers"
    private let kPathServices = "/serviceTypes"
    private let kPathAppointments = "/appointments"
    
    init(with barbershop: Barbershop) {

        self.barbershop = barbershop
        self.refresh()

    }

    func getBarbershop(uuid: String) -> Barbershop? {
        if uuid == self.barbershop.uuid {return self.barbershop} else {return nil}
    }
    
    func getPerson(uuid: String) -> Person? {
        return nil
    }
    
    func getPerson(uuid: String, completion: @escaping (Person?, Error?) -> ()) -> Void {
        
        let decoder = FirestoreDecoder()
        
        if self.firestore == nil { self.firestore = Firestore.firestore() }
        
        let path = self.personsPath.appending(uuid)
        let reference = self.firestore!.document(path)
        reference.getDocument { (snapshot, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            var person: Person?
            if let document = snapshot, var dict = document.data() {

                dict["uuid"] = document.documentID
                do {person = try decoder.decode(Person.self, from: dict)
                } catch {debugPrint(error)}
                
            }
            
            completion(person, nil)
            
        }
        
    }
    
    func saveBarbershop(_ object: Barbershop, completion: @escaping (Bool, Error?) -> Void) {}
    
    func savePerson(_ object: Person, completion: @escaping (Bool, Error?) -> Void) {
        
        var dict = object.asDict
        dict.removeValue(forKey: "uuid")
        
        let path = self.personsPath
        firestore?.collection(path).document(object.uuid).setData(dict, completion: { (error) in
            
            if error != nil {completion(false, error)} else {completion(true, nil)}
            
        })
        
    }

    func createAppointment(_ object: Appointment, type: AppointmentType, barber: Barber, customer: Person, completion: @escaping (Bool, Error?) -> Void) -> Void {

        var dict = object.asDict
        dict.removeValue(forKey: Appointment.CodingKeys.uuid.stringValue)
        dict[Appointment.CodingKeys.interval.stringValue] = type.minutes
        dict[Appointment.CodingKeys.serviceType.stringValue] = type.index
        dict[Appointment.CodingKeys.status.stringValue] = Appointment.Status.requested.rawValue
        dict[Appointment.CodingKeys.barberUUID.stringValue] = barber.uuid
        dict[Appointment.CodingKeys.customerUUID.stringValue] = customer.uuid
        dict[Appointment.CodingKeys.customerName.stringValue] = customer.name
        
        let path = self.basePath.appending(kPathAppointments)
        firestore?.collection(path).document(object.uuid).setData(dict, completion: { (error) in
            
            if error != nil {completion(false, error)} else {completion(true, nil)}
            
        })
        
    }
    
    func saveAppointment(_ object: Appointment, completion: @escaping (Bool, Error?) -> Void) {}
    
    func refresh() -> Void {
        
        let firestore = Firestore.firestore()
        let settings = firestore.settings
        settings.areTimestampsInSnapshotsEnabled = true
        firestore.settings = settings
        
        self.firestore = firestore

        let fireReference = firestore.document(basePath)
        fireReference.getDocument { (snapshot, error) in
            
            guard let doc = snapshot, doc.exists, var dict = doc.data() else { return }
            dict["uuid"] = self.barbershop.uuid
            self.barbershop.updateFromCloud(dict: dict)
            
        }
        
        let decoder = FirestoreDecoder()
        
        let barbersPath = basePath.appending("/barbers")
        firestore.collection(barbersPath).getDocuments { (snapshot, error) in
            
            guard let col = snapshot, !col.isEmpty else {return}
            let itens: [Barber] = col.documents.compactMap({
                
                var dict = $0.data()
                dict["uuid"] = $0.documentID
                return try? decoder.decode(Barber.self, from: dict)
                
            })
            
            self.barbershop.updateBarbersFromCloud(barbers: itens)
            
        }
        
        let servicesPath = basePath.appending("/serviceTypes")
        firestore.collection(servicesPath).getDocuments { (snapshot, error) in
            
            guard let col = snapshot, !col.isEmpty else {return}
            let itens = col.documents.compactMap({ try? decoder.decode(AppointmentType.self, from: $0.data())})
            self.barbershop.updateServicesFromCloud(services: itens)
            
        }
        
        let firstHourOfToday = Timestamp(date: barbershop.startTime(for: Date()))
        let appointmentsPath = basePath.appending("/appointments")
        self.listener = firestore.collection(appointmentsPath).whereField("startDate", isGreaterThan: firstHourOfToday).addSnapshotListener { (snapshot, error) in
            
            guard let col = snapshot, !col.isEmpty else {return}
            let itens: [Appointment] = col.documents.compactMap({
                
                var dict = $0.data()
                dict["uuid"] = $0.documentID
                return self.parseAppointment(dict: dict)

            })
            
            self.barbershop.updateAppointmentsFromCloud(appointments: itens)
            
        }
        
    }
    
    func releaseResources() {
        self.listener = nil
        self.firestore = nil
    }
    
    private func parseAppointment(dict: [String:Any]) -> Appointment? {
        
        let _uuid = dict[Appointment.CodingKeys.uuid.stringValue] as? String
        let _date = dict[Appointment.CodingKeys.startDate.stringValue] as? Timestamp
        let _interval = dict[Appointment.CodingKeys.interval.stringValue] as? Int
        let _type = dict[Appointment.CodingKeys.serviceType.stringValue] as? Int
        let _status = dict[Appointment.CodingKeys.status.stringValue] as? String
        let _barberId = dict[Appointment.CodingKeys.barberUUID.stringValue] as? String
        let _custId = dict[Appointment.CodingKeys.customerUUID.stringValue] as? String
        let _custName = dict[Appointment.CodingKeys.customerName.stringValue] as? String
        
        guard let uuid = _uuid else {return nil}
        guard let date = _date?.dateValue() else {return nil}
        
        guard let intervalInt = _interval else {return nil}
        let interval = Double(intervalInt)
        
        guard let typeIndex = _type, let type = self.barbershop.serviceTypes.filter({ $0.index == typeIndex}).first else {return nil}
        guard let statusKey = _status, let status = Appointment.Status(rawValue: statusKey) else {return nil}
        guard let barberId = _barberId else {return nil}
        guard let customerId = _custId else {return nil}
        guard let customerName = _custName else {return nil}
        
        let appointment = Appointment(uuid: uuid, time: date, interval: interval, type: type, status: status, barberId: barberId, customerId: customerId, customerName: customerName)
        return appointment
        
    }
    
}
