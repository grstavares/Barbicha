//
//  AppActions.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 17/05/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation

enum AppAction {
    
    case showBarbershop(Barbershop)
    case showBarber(Barbershop, Barber)
    case showLocation(Barbershop)
    case showGallery
    case showProfile
    case showLogin
    case requestAppointment(Barbershop, Barber, Appointment, AppointmentType, Person)
    case requestCancellation(Appointment, Person)
    case requestChange(Appointment)
    case cancelAppointment(Appointment)
    case blockAppointment(Appointment)
    case endAppointment(Appointment)
    case evaluate(Appointment)
    
    case sendMessage(Person, Person)
    case makeCall(Person)
    
    case registerUser(Person, String)
    case loginWithEmailAndPassword(String, String)
    case logOut

}
