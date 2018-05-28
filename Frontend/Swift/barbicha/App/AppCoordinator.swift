//
//  AppCoordinator.swift
//  barbicha
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import UIKit

class AppCoordinator {

    private var currentUser: Person?
    private var barbershop: Barbershop!
    
    private var userPool: AuthProvider?
    private var dataProvider: DataProvider?
    
    public var loggedUser: Person? {return self.currentUser}

    public init(with shop: Barbershop) {
        
        self.barbershop = shop
        
        let provider = FirestoreProvider(with: shop)
        self.dataProvider = provider
        self.userPool = FireAuthProvider(dataProvider: provider)
        
    }

    public func rootVC() -> UIViewController {
        
        let rootVC = BarbershopVC.instantiate(self.barbershop, using: self)
        return rootVC!
        
    }

    public func customerInfo(uuid: String) -> Person? {
        
        return self.dataProvider?.getPerson(uuid: uuid)
        
    }
    
    public func performAction(from: UIViewController, action: AppAction) -> Void {
        
        switch action {

        case .showLogin:
            let loginVC = LoginVC.instantiate(using: self)
            from.present(loginVC!, animated: true, completion: nil)
            
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
            
            let nextVC = ProfileVC.instantiate(with: self.loggedUser, using: self)
            
//            let transitionDelegate = ProfileTransitionerDelegate()
//            from.transitioningDelegate = transitionDelegate
//            nextVC?.transitioningDelegate = transitionDelegate
//            nextVC?.modalPresentationStyle = .custom
            
            from.present(nextVC!, animated: true, completion: nil)

        case .requestAppointment( _, let barber, let appointment, let type, let cust):

            self.dataProvider?.createAppointment(appointment, type: type, barber: barber, customer: cust, completion: { (success, error) in
                
                if error != nil {debugPrint("ERROR | ERROR | ERROR -> \(error?.localizedDescription ?? "NoDescription")")}
                
            })
            
        case .registerUser(let user, let pwd):
            
            if user.uuid == pwd {debugPrint("EmptyTest")}
            
        case .loginWithEmailAndPassword(_, _):
            
            debugPrint("Imvalid Action -> This must be called in async mode")

        case .logOut:
            
            self.logOut()
            
        default:
            debugPrint("\(action) not implemented!")
            
        }
        
    }
    
    public func performAction(from: UIViewController, action: AppAction, handler: @escaping (Bool, Error?) -> Void) -> Void {
        
        switch action {
        case .registerUser(let person, let password):
            
            if let messageToken = self.getMessageToken(), messageToken != person.messageToken {person.messageToken = messageToken}
            
            self.userPool?.registerUser(person: person, password: password, completion: { (person, error) in
                
                guard error == nil else {
                    handler(false, error)
                    return
                }
                
                guard person != nil else {
                    handler(false, nil)
                    return
                }
                
                self.currentUser = person!
                handler(true, nil)
                
            })

        case .loginWithEmailAndPassword(let email, let password):
            
            self.userPool?.authenticate(email: email, password: password, completion: { (person, error) in
                
                guard error == nil else {
                    handler(false, error)
                    return
                }

                if person != nil, let messageToken = self.getMessageToken(), messageToken != person?.messageToken {
                    person?.messageToken = messageToken
                    self.dataProvider?.savePerson(person!, completion: { (_, _) in return})
                }
                
                self.currentUser = person
                handler(true, nil)

            })
            
        case .logOut:
            
            self.logOut()
            handler(true, nil)
            
            
        default:
            return
            
        }
        
    }
    
    public func saveMessageToken(token: String) -> Void {
        
        debugPrint("Wiil Save Token")
        
        if let person = self.currentUser {
            person.messageToken = token
            self.dataProvider?.savePerson(person, completion: { (success, error) in if (success) {debugPrint("Token Saved!")} })
        }
        
    }
    
    private func logOut() -> Void {
        self.userPool?.signOut();
        self.currentUser = nil
    }
    
    private func getMessageToken() -> String? {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.messageToken
        
    }
    
    private func persistedUsernameAndPwd() -> (String, String)? {
        
        return ("1B8F87ED-07A7-4B44-BB78-C0CE0FD9902A", "12345")
        
    }
    
}

