//
//  MockData.swift
//  barbicha
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
extension AppCoordinator {
    
    public var mockBarbershop: Barbershop {
        
        let main = Bundle.main
        let url0 = main.url(forResource: "brotherhood", withExtension: "png")
        let url1 = main.url(forResource: "barbeiro01", withExtension: "jpg")
        let url2 = main.url(forResource: "barbeiro02", withExtension: "jpg")
        let url3 = main.url(forResource: "barbeiro04", withExtension: "jpg")
        
        let shop = Barbershop(name: "Brotherhood", imageUrl: url0)
        let barber1 = Barber(name: "Jonas Rex", imageUrl: url1)
        let barber2 = Barber(name: "Anderson", imageUrl: url2)
        let barber3 = Barber(name: "Douglas", imageUrl: url3)
        
        shop.addBarber(barber1)
        shop.addBarber(barber2)
        shop.addBarber(barber3)
        
        return shop
        
    }
    
}
