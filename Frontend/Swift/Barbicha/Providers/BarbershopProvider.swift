//
//  BarbershopProvider.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 22/05/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import UIKit
import PlazazCore

class BarbershopProvider: DataProvider  {
    func releaseResources() {return}
    

    public static let shared = BarbershopProvider()
    
    private init() {
        
        self.loadMockData()
        
    }

    private var mapBarbershop: [String:Barbershop] = [:]
    private var mapPersons: [String:PlazazPerson] = [:]
    
    public var barbershops: [Barbershop] {return self.mapBarbershop.compactMap({ $1 })}
    public var persons: [PlazazPerson] {return self.mapPersons.compactMap({ $1 })}

    public func getBarbershop(uuid: String) -> Barbershop? {return nil}
    public func getPerson(uuid: String) -> PlazazPerson? {return nil}
    
    public func saveBarbershop(_ object: Barbershop, completion: @escaping (Bool, Error?) -> Void) -> Void {}
    public func savePerson(_ object: Barbershop, completion: @escaping (Bool, Error?) -> Void) -> Void {}
    
    public func saveAppointment(_ object: Appointment, completion: @escaping (Bool, Error?) -> Void) -> Void {}
    
}

extension BarbershopProvider {
    
    private func loadMockData() -> Void {
        
        let main = Bundle.main
        
        let image = UIImage(named: "mockGustavo")!
        let customer = Customer(name: "Gustavo Tavares", alias: "GusTavares", phone: "+55-61", email: "spam@spam.com")
        customer.alias = "GusTavares"
        customer.imageData = UIImagePNGRepresentation(image)
        self.mapPersons[customer.uuid] = customer

        let url1 = main.url(forResource: "barbeiro01", withExtension: "jpg")
        let barber1 = Barber(name: "Jonas Rex", imageUrl: url1)
        
        let url2 = main.url(forResource: "barbeiro02", withExtension: "jpg")
        let barber2 = Barber(name: "Anderson", imageUrl: url2)
        
        let url3 = main.url(forResource: "barbeiro04", withExtension: "jpg")
        let barber3 = Barber(name: "Douglas", imageUrl: url3)
        
        let url4 = main.url(forResource: "brotherhood", withExtension: "png")
        let shop = Barbershop(name: "Brotherhood", imageUrl: url4, services: self.servicos)
        shop.location = (-15.834731, -48.013629)
        shop.addBarber(barber1)
        shop.addBarber(barber2)
        shop.addBarber(barber3)
        self.mapBarbershop[shop.uuid] = shop
        
        let barber4 = Barber(name: "Jonas Beto", imageUrl: url1)
        let barber5 = Barber(name: "AndersonBeto", imageUrl: url2)
        let barber6 = Barber(name: "DouglasBeto", imageUrl: url3)
        
        let url5 = main.url(forResource: "barbeariaBeto", withExtension: "jpg")
        let shop2 = Barbershop(name: "Barbearia do Beto", imageUrl: url5, services: self.servicos)
        shop2.location = (-15.841260, -48.027794)
        shop2.addBarber(barber4)
        shop2.addBarber(barber5)
        shop2.addBarber(barber6)
        self.mapBarbershop[shop2.uuid] = shop2
        
    }
    
    private var servicos: [AppointmentType] {
        
        let barba = AppointmentType(index: 0, label: "Barba", minutes: 30)
        let cabelo = AppointmentType(index: 1, label: "Cabelo", minutes: 30)
        let barbCab = AppointmentType(index: 2, label: "Barba&Cabelo", minutes: 30)
        return [barba, cabelo, barbCab]
        
    }
    
}
