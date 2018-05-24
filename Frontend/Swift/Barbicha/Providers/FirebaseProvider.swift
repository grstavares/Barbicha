//
//  FirebaseProvider.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 23/05/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
import PlazazCore
import FirebaseFirestore
import CodableFirebase

class FirebaseProvider: DataProvider {

    private var firestore: Firestore?
    private var listener: ListenerRegistration?
    private var barbershop: Barbershop
    
    init(with barbershop: Barbershop) {

        
        self.barbershop = barbershop
        self.refresh()

    }

    func getBarbershop(uuid: String) -> Barbershop? {
        if uuid == self.barbershop.uuid {return self.barbershop} else {return nil}
    }
    
    func getPerson(uuid: String) -> PlazazPerson? {
        return nil
    }
    
    func saveBarbershop(_ object: Barbershop, completion: @escaping (Bool, Error?) -> Void) {}
    
    func savePerson(_ object: Barbershop, completion: @escaping (Bool, Error?) -> Void) {}
    
    func saveAppointment(_ object: Appointment, completion: @escaping (Bool, Error?) -> Void) {}
    
    func refresh() -> Void {
        
        let firestore = Firestore.firestore()
        self.firestore = firestore
        
        let path: String = "barbershops/" +  barbershop.uuid
        let fireReference = firestore.document(path)
        fireReference.getDocument { (snapshot, error) in
            
            guard let doc = snapshot, doc.exists else { return }
            var dict = doc.data()
            dict["uuid"] = self.barbershop.uuid
            self.barbershop.updateFromCloud(dict: dict)
            
        }
        
        let decoder = FirestoreDecoder()
        
        let barbersPath = path.appending("/barbers")
        firestore.collection(barbersPath).getDocuments { (snapshot, error) in
            
            guard let col = snapshot, !col.isEmpty else {return}
            let itens: [Barber] = col.documents.compactMap({
                
                var dict = $0.data()
                dict["uuid"] = $0.documentID
                return try? decoder.decode(Barber.self, from: dict)
                
            })
            
            self.barbershop.updateBarbersFromCloud(barbers: itens)
            
        }
        
        let servicesPath = path.appending("/serviceTypes")
        firestore.collection(servicesPath).getDocuments { (snapshot, error) in
            
            guard let col = snapshot, !col.isEmpty else {return}
            let itens = col.documents.compactMap({ try? decoder.decode(AppointmentType.self, from: $0.data())})
            self.barbershop.updateServicesFromCloud(services: itens)
            
        }
        
        let appointmentsPath = path.appending("/appointments")
        self.listener = firestore.collection(appointmentsPath).addSnapshotListener { (snapshot, error) in
            
            guard let col = snapshot, !col.isEmpty else {return}
            let itens = col.documents.compactMap({ try? decoder.decode(Appointment.self, from: $0.data())})
            self.barbershop.updateAppointmentsFromCloud(appointments: itens)
            
        }
        
    }
    
    func releaseResources() {
        self.listener = nil
        self.firestore = nil
    }
    
}
