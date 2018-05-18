//
//  AppActions.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 17/05/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
import PlazazCore

enum AppAction {
    
    case showCollection(ExposableAsCollection)
    case showBarbershop(Barbershop)
    case showBarber(Barbershop, Barber)
    case showLocation(ExposableAsCollection)
    case showGallery
    case showProfile
    case makeAppointment(Barbershop, Barber, Appointment, AppointmentType, PlazazPerson)
    case confirmAppointment
    case removeAppointment
    
    case loginUser(String, String)
    
}
