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
    
    static let shared: AppCoordinator = AppCoordinator()
    
    private var currentUser: PlazazPerson?
    public var loggedUser: PlazazPerson? {return self.currentUser}

    private init() {
        
        if let userInfo = self.persistedUsernameAndPwd() {
            _ = self.userLogin(username: userInfo.0, password: userInfo.1)
        }
        
    }

    public func rootVC() -> UIViewController {
        
        let mock = self.mainCollection
        let rootVC = CollectionVC.instantiate(with: mock, using: self, canNavigateBack: false)
        return rootVC!
        
    }

    public func performAction(from: UIViewController, action: AppAction) -> Void {
        
        
        switch action {
        case .showCollection(let collection):
            let nextVC = CollectionVC.instantiate(with: collection, using: self, canNavigateBack: true)
            from.present(nextVC!, animated: true, completion: nil)
            
        case .showBarbershop(let shop):
            let nextVC = CollectionVC.instantiate(with: shop, using: self, canNavigateBack: true)
            from.present(nextVC!, animated: true, completion: nil)

        case .showBarber(let shop, let barber):
            let nextVC = CollectionItemVC.instantiate(with: shop, and: barber, using: self)
            from.present(nextVC!, animated: true, completion: nil)
            
        case .showLocation(let shop):
            let nextVC = LocationVC.instantiate(using: self, show: shop)
            from.present(nextVC!, animated: true, completion: nil)
            
        case .showGallery:
            let nextVC = GalleryVC.instantiate(using: self)
            from.present(nextVC!, animated: true, completion: nil)

        case .showProfile:
            
            let nextVC = ProfileVC.instantiate(with: self.loggedUser, using: self)
            
//            let transitionDelegate = ProfileTransitionerDelegate()
//            from.transitioningDelegate = transitionDelegate
//            nextVC?.transitioningDelegate = transitionDelegate
//            nextVC?.modalPresentationStyle = .custom
            
            from.present(nextVC!, animated: true, completion: nil)

        case .makeAppointment(let shop, let barber, let date, let type, let cust):

            shop.schedulle(for: date, type: type, with: barber, customer: cust) { (schedulleResult) in
                
                if schedulleResult {return} else {debugPrint("Failure!")}
                
            }
        
        case .loginUser(let username, let password):
            
            if !self.userLogin(username: username, password: password) {debugPrint("Login Failed!")}

        default: return
            
        }
        
    }
    
    private func userLogin(username: String, password: String) -> Bool {
        
        let mock = mockUser
        if username == mock.email || username == mock.alias {
            
            if password == "12345" {
                self.currentUser = mock
                return true
            } else {return false}
            
        } else {return false}

    }
    
    private func persistedUsernameAndPwd() -> (String, String)? {
        
        return ("spam@spam.com", "12345")
        
    }
    
}

