//
//  MockData.swift
//  barbicha
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import UIKit
import PlazazCore

extension AppCoordinator {
    
    public var mainCollection: ExposableAsCollection {
        
        let bundle = Bundle.main
        let name = UIApplication.shared.alternateIconName ?? "BarbiCHA--"
        let imageUrl = bundle.url(forResource: "AppImage", withExtension: "png")
        let imageDta = try? Data(contentsOf: imageUrl!)
        let main = BarbershopCollection(name: name, pitchLine: "Sua Barbearia", image: imageDta, itens: [self.brotherhood, self.doBeto])
        return main
        
    }
    
    public var mockUser: PlazazPerson {
        
        let image = UIImage(named: "mockGustavo")!
        let customer = Customer(name: "Gustavo Tavares", phone: "+55-61", email: "spam@spam.com")
        customer.alias = "GusTavares"
        customer.imageData = UIImagePNGRepresentation(image)
        return customer
    }
    
    public var brotherhood: Barbershop {
        
        let main = Bundle.main
        let url0 = main.url(forResource: "brotherhood", withExtension: "png")
        let url1 = main.url(forResource: "barbeiro01", withExtension: "jpg")
        let url2 = main.url(forResource: "barbeiro02", withExtension: "jpg")
        let url3 = main.url(forResource: "barbeiro04", withExtension: "jpg")

        let shop = Barbershop(name: "Brotherhood", imageUrl: url0, services: self.servicos)
        let barber1 = Barber(name: "Jonas Rex", imageUrl: url1)
        let barber2 = Barber(name: "Anderson", imageUrl: url2)
        let barber3 = Barber(name: "Douglas", imageUrl: url3)
        
        shop.location = (-15.834731, -48.013629)
        shop.addBarber(barber1)
        shop.addBarber(barber2)
        shop.addBarber(barber3)
        
        return shop
        
    }
    
    private var doBeto: Barbershop {
        
        let main = Bundle.main
        let url0 = main.url(forResource: "barbeariaBeto", withExtension: "jpg")
        let url1 = main.url(forResource: "barbeiro01", withExtension: "jpg")
        let url2 = main.url(forResource: "barbeiro02", withExtension: "jpg")
        let url3 = main.url(forResource: "barbeiro03", withExtension: "jpg")
        
        let shop = Barbershop(name: "Barbearia do Beto", imageUrl: url0, services: self.servicos)
        let barber1 = Barber(name: "Jonas Rex do Beto", imageUrl: url1)
        let barber2 = Barber(name: "Anderson", imageUrl: url2)
        let barber3 = Barber(name: "Outro Cara", imageUrl: url3)
        
        shop.location = (-15.841260, -48.027794)
        shop.addBarber(barber1)
        shop.addBarber(barber2)
        shop.addBarber(barber3)
        
        return shop
    }
    
    private var servicos: [AppointmentType] {
        
        
        let barba = AppointmentType(index: 0, label: "Barba", time: 30)
        let cabelo = AppointmentType(index: 1, label: "Cabelo", time: 30)
        let barbCab = AppointmentType(index: 2, label: "Barba&Cabelo", time: 30)
        return [barba, cabelo, barbCab]
        
    }
    
}
