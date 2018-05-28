//
//  DataProvider.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 23/05/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation

protocol DataProvider {

    func getBarbershop(uuid: String) -> Barbershop?
    
    func getPerson(uuid: String) -> Person?
    func getPerson(uuid: String, completion: @escaping (Person?, Error?) -> ()) -> Void
    
    func saveBarbershop(_ object: Barbershop, completion: @escaping (Bool, Error?) -> Void) -> Void
    func savePerson(_ object: Person, completion: @escaping (Bool, Error?) -> Void) -> Void
    
    func createAppointment(_ object: Appointment, type: AppointmentType, barber: Barber, customer: Person, completion: @escaping (Bool, Error?) -> Void) -> Void
    func saveAppointment(_ object: Appointment, completion: @escaping (Bool, Error?) -> Void) -> Void
    
    func releaseResources() -> Void
    
}
