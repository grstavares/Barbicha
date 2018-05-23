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

class FirebaseProvider: DataProvider {

    private var firestore: Firestore!
    private var barbershop: Barbershop
    
    init(with barbershop: Barbershop) {

        self.firestore = Firestore.firestore()
        self.barbershop = barbershop
        
        self.firestore.collection("barbershops").getDocuments { (snapshot, error) in
            
            guard error == nil else {
                debugPrint(error ?? "NoError")
                return
            }

            debugPrint("Documentos found on snapshot -> \(snapshot?.count ?? 0)")
            var barbershops: [Barbershop] = []
            
            if let documents = snapshot?.documents {
                barbershops = documents.compactMap({ Barbershop(firestoreDocument: $0) })
            }

            barbershops.forEach({ debugPrint("in Firebase \($0.description)") })
            
        }

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

}
