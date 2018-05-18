//
//  Customer.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 17/05/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
import PlazazCore
import SipHash

public class Customer: PlazazPerson {

    public var uuid: String
    public var name: String?

    public var imageUrl: URL?
    public var imageData: Data?
    
    public var alias: String?
    public var phone: String?
    public var email: String?
    
    public init(name: String, phone: String?, email: String?) {
        
        self.uuid = PlazazCoreHelpers.newUUID(for: Customer.self)
        self.name = name
        self.phone = phone
        self.email = email
        
    }
    
}

extension Customer: SipHashable {
    
    public func appendHashes(to hasher: inout SipHasher) {
        hasher.append(self.uuid)
        hasher.append(self.name)
        hasher.append(self.phone)
        hasher.append(self.email)
        hasher.append(self.alias)
        hasher.append(self.imageUrl)
        hasher.append(self.imageData)
    }
    
    public static func == (lhs: Customer, rhs: Customer) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

}
