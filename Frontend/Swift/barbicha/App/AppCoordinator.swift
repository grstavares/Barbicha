//
//  AppCoordinator.swift
//  barbicha
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
import PlazazCore

class AppCoordinator {

    private var currentUser: PlazazUser?
    private var barbershop: Barbershop!
    
    private var userPool: UserProvider?
    private var dataProvider: DataProvider?
    
    public var loggedUser: PlazazUser? {return self.currentUser}

    public init(with shop: Barbershop) {
        
        self.barbershop = shop
        self.userPool = UserPool.shared
        self.dataProvider = FirebaseProvider(with: shop)

    }

    public func rootVC() -> UIViewController {
        
        let rootVC = BarbershopVC.instantiate(self.barbershop, using: self)
        return rootVC!
        
    }

    public func customerInfo(uuid: String) -> PlazazPerson? {
        
        return self.dataProvider?.getPerson(uuid: uuid)
        
    }
    
    public func performAction(from: UIViewController, action: AppAction) -> Void {
        
        switch action {

        case .showBarbershop(let shop):
            let nextVC = BarbershopVC.instantiate(shop, using: self)
            from.present(nextVC!, animated: true, completion: nil)

        case .showBarber(let shop, let barber):
            let nextVC = BarberVC.instantiate(with: shop, and: barber, using: self)
            from.present(nextVC!, animated: true, completion: nil)
            
        case .showLocation(let shop):
            let nextVC = LocationVC.instantiate(using: self, show: shop)
            from.present(nextVC!, animated: true, completion: nil)
            
        case .showGallery:
            let nextVC = GalleryVC.instantiate(using: self)
            from.present(nextVC!, animated: true, completion: nil)

        case .showProfile:
            
            let nextVC = ProfileVC.instantiate(with: self.loggedUser?.person, using: self)
            
//            let transitionDelegate = ProfileTransitionerDelegate()
//            from.transitioningDelegate = transitionDelegate
//            nextVC?.transitioningDelegate = transitionDelegate
//            nextVC?.modalPresentationStyle = .custom
            
            from.present(nextVC!, animated: true, completion: nil)

        case .requestAppointment(let shop, let barber, let date, let type, let cust):

            shop.schedulle(for: date, type: type, with: barber, customer: cust) { (schedulleResult) in
                
                if schedulleResult {return} else {debugPrint("Failure!")}
                
            }
            
        case .registerUser(let user, let pwd):
            
            self.userPool?.registerNewUser(user, password: pwd, completion: { (success, returnedUser, error) in
                
                guard error == nil else {
                    debugPrint("Error!")
                    return
                }
                
                guard returnedUser != nil else {
                    debugPrint("Error!")
                    return
                }
                
                guard success else {
                    debugPrint("Error!")
                    return
                }

            })
            
        case .loginUser(let username, let password):
            
            self.userLogin(username: username, password: password)

        default:
            debugPrint("\(action) not implemented!")
            
        }
        
    }
    
    private func userLogin(username: String, password: String) -> Void {
        
        self.userPool?.authenticate(username: username, password: password, completion: { (success, user, error) in
            
            if success && user != nil {self.currentUser = user
            } else {debugPrint("Login Failed!")}
            
        })
        
    }
    
    private func persistedUsernameAndPwd() -> (String, String)? {
        
        return ("GusTavares", "12345")
        
    }
    
}

