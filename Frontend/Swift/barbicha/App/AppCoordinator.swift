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
    
    static let shared: AppCoordinator = AppCoordinator()
    private init() {}
    
    public func authenticate(user: PlazazUser, password: String, completion: @escaping (Bool, Error) -> ()) -> Void {}
    public func authenticate(user: PlazazUser, token: String, completion: @escaping (Bool, Error) -> ()) -> Void {}
    public func deauthenticate(user: PlazazUser, completion: @escaping (Bool, Error) -> ()) -> Void {}
    
    public func rootVC() -> UIViewController {
        
        let mock = self.mainCollection
        let rootVC = CollectionVC.instantiate(with: mock, using: self, canNavigateBack: false)
        return rootVC!
        
    }
    
    public enum Action {
        case showCollection(ExposableAsCollection)
        case showBarbershop(Barbershop)
        case showBarber(Barbershop, Barber)
        case showLocation
        case showGallery
        case showProfile(AnyObject?)
    }
    
    public func performAction(from: UIViewController, action: Action) -> Void {
        
        
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
            
        case .showLocation:
            let nextVC = LocationVC.instantiate(using: self)
            from.present(nextVC!, animated: true, completion: nil)
            
        case .showGallery:
            let nextVC = GalleryVC.instantiate(using: self)
            from.present(nextVC!, animated: true, completion: nil)

        case .showProfile( _):
            
            let userData = currentUser == nil ? self.mockUserData : self.userDataFromUser(user: currentUser!)
            let nextVC = ProfileVC.instantiate(with: userData, using: self)
            
            let transitionDelegate = ProfileTransitionerDelegate()
            from.transitioningDelegate = transitionDelegate
            nextVC?.transitioningDelegate = transitionDelegate
            nextVC?.modalPresentationStyle = .custom
            
            from.present(nextVC!, animated: true, completion: nil)

        }
        
    }
    
    private func userDataFromUser(user: PlazazUser) -> UserData {
        
        let uuid = user.uuid
        let name = user.name
        
        let userData = UserData.init(uuid: uuid, name: name, apelido: "Apelido", phone: "+55 61", email: "@globo.com", image: nil)
        return userData
        
    }
    
    
}

