//
//  DataProvider.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 23/05/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
import PlazazCore

protocol DataProvider {

    func getBarbershop(uuid: String) -> Barbershop?
    func getPerson(uuid: String) -> PlazazPerson?
    
    func saveBarbershop(_ object: Barbershop, completion: @escaping (Bool, Error?) -> Void) -> Void
    func savePerson(_ object: Barbershop, completion: @escaping (Bool, Error?) -> Void) -> Void
    
    func saveAppointment(_ object: Appointment, completion: @escaping (Bool, Error?) -> Void) -> Void
    
}
