//
//  Barber.swift
//  barbicha
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
import PlazazCore
import SipHash

class Barber: PlazazPerson {

    public var uuid: String
    public var name: String?
    public var imageUrl: URL?
    public var imageData: Data?

    public var alias: String?
    public var phone: String?
    public var email: String?
    
    init(name: String, imageUrl: URL?) {
        
        self.uuid = PlazazCoreHelpers.newUUID(for: Barber.self)
        self.name = name
        self.imageUrl = imageUrl
        
        if imageUrl != nil {
            
            AppDelegate.imageFromUrl(url: imageUrl!) { (data, error) in
                
                guard error == nil else {return}
                self.imageData = data
                self.informChange(type: .imageChanged, object: self)
                
            }
            
        }
        
    }
    
    private func informChange(type: CollectionItemObservableEvent, object: Barber) -> Void {}
    
}

extension Barber: CustomStringConvertible {
    
    var description: String {return "Barber: [\(self.uuid)] \(self.name ?? "NoName")"}
    
}

extension Barber: SipHashable {
    
    public func appendHashes(to hasher: inout SipHasher) {
        hasher.append(self.uuid)
        hasher.append(self.name)
        hasher.append(self.imageUrl)
        hasher.append(self.imageData)
    }
    
    public static func == (lhs: Barber, rhs: Barber) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
}

extension Barber: ExposableAsDetails {
    
    var image: Data? {return self.imageData}
    var mainLabel: String {return self.name ?? ""}
    var detail: String? {return nil}
    var moreDetail: String? {return nil}

    var cellImage: Data? {return self.image}
    var cellLabel: String? {return self.mainLabel}
    var reference: Exposable {return self}
    
}
