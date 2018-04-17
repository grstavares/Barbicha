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
    private init() {}
    
    public func authenticate(user: PlazazUser, password: String, completion: @escaping (Bool, Error) -> ()) -> Void {}
    public func authenticate(user: PlazazUser, token: String, completion: @escaping (Bool, Error) -> ()) -> Void {}
    public func deauthenticate(user: PlazazUser, completion: @escaping (Bool, Error) -> ()) -> Void {}
    
    public func rootVC() -> UIViewController {
        
        let mock = self.mockBarbershop
        let rootVC = CollectionVC.instantiate(with: mock, using: self)
        return rootVC!
        
    }
    
    public func performAction(from: UIViewController, action: Action) -> Void {
        
        
        switch action {
        case .showCollection(let collection):
            debugPrint("will show collection = \(collection.mainLabel)")
            
        case .showDetail(let collectionItem):
            let nextVC = CollectionItemVC.instantiate(with: collectionItem, using: self)
            from.present(nextVC!, animated: true, completion: nil)
        
        case .showLocation:
            let nextVC = LocationVC.instantiate(using: self)
            from.present(nextVC!, animated: true, completion: nil)
            
        case .showGallery:
            let nextVC = GalleryVC.instantiate(using: self)
            from.present(nextVC!, animated: true, completion: nil)
            
        }
        
    }
    
    public enum Action {
        case showCollection(ExposableAsCollection)
        case showDetail(ExposableAsDetails)
        case showLocation
        case showGallery
    }
    
    
    
}

