//
//  MockData.swift
//  barbicha
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import UIKit
extension AppCoordinator {
    
    public var mainCollection: ExposableAsCollection {
        
        let bundle = Bundle.main
        let name = UIApplication.shared.alternateIconName ?? "BarbiCHA--"
        let imageUrl = bundle.url(forResource: "AppImage", withExtension: "png")
        let imageDta = try? Data(contentsOf: imageUrl!)
        let main = MainCollection(name: name, pitchLine: "Sua Barbearia", image: imageDta, itens: [self.brotherhood, self.doBeto])
        return main
        
    }
    
    public var mockUserData: UserData {
        let image = UIImage(named: "mockGustavo")
        return UserData(uuid: "mew", name: "Gustavo Roberto Silva Tavares", apelido: "GusTavares", phone: nil, email: "email@teste.com", image: image)
    }
    
    public var brotherhood: Barbershop {
        
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
    
    private var doBeto: Barbershop {
        
        let main = Bundle.main
        let url0 = main.url(forResource: "barbeariaBeto", withExtension: "jpg")
        let url1 = main.url(forResource: "barbeiro01", withExtension: "jpg")
        let url2 = main.url(forResource: "barbeiro02", withExtension: "jpg")
        let url3 = main.url(forResource: "barbeiro03", withExtension: "jpg")
        
        let shop = Barbershop(name: "Barbearia do Beto", imageUrl: url0)
        let barber1 = Barber(name: "Jonas Rex do Beto", imageUrl: url1)
        let barber2 = Barber(name: "Anderson", imageUrl: url2)
        let barber3 = Barber(name: "Outro Cara", imageUrl: url3)
        
        shop.addBarber(barber1)
        shop.addBarber(barber2)
        shop.addBarber(barber3)
        
        return shop
    }
    
}
