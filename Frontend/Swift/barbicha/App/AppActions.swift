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
    
    case showBarbershop(Barbershop)
    case showBarber(Barbershop, Barber)
    case showLocation(Barbershop)
    case showGallery
    case showProfile
    case requestAppointment(Barbershop, Barber, Appointment, AppointmentType, PlazazPerson)
    case requestCancellation(Appointment, PlazazPerson)
    case requestChange(Appointment)
    case cancelAppointment(Appointment)
    case blockAppointment(Appointment)
    case endAppointment(Appointment)
    case evaluate(Appointment)
    
    case sendMessage(PlazazPerson, PlazazPerson)
    case makeCall(PlazazPerson)
    
    case registerUser(PlazazUser, String)
    case loginUser(String, String)

}
