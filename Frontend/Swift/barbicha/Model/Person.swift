//
//  Customer.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 17/05/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
import SipHash

public class Person: Codable {

    public var uuid: String
    public var name: String?

    public var imageUrl: URL?
    public var imageData: Data?
    
    public var alias: String?
    public var phone: String?
    public var email: String?
    
    public var messageToken: String?
    
    public init(uuid: String, name: String?, alias: String?, phone: String?, email: String?) {
        self.uuid = uuid
        self.name = name
        self.alias = alias
        self.phone = phone
        self.email = email
    }
    
    convenience public init(name: String?, alias: String?, phone: String?, email: String?) {
        
        let uuid = AppUtilities.newUUID(for: Person.self)
        self.init(uuid: uuid, name: name, alias: alias, phone: phone, email: email)
        
    }

    required public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let _uuid = try values.decode(String.self, forKey: .uuid)
        let _name = try values.decodeIfPresent(String.self, forKey: .name)
        let _alias = try values.decodeIfPresent(String.self, forKey: .alias)
        let _phone = try values.decodeIfPresent(String.self, forKey: .phone)
        let _email = try values.decodeIfPresent(String.self, forKey: .email)
        
        self.uuid = _uuid
        self.name = _name
        self.alias = _alias
        self.phone = _phone
        self.email = _email
        
        if let _url = try values.decodeIfPresent(String.self, forKey: .imageUrl), let url = URL(string: _url) {
            self.imageUrl = url
            self.refreshImage()
        }
        
    }

    public var asDict: [String:Any] {
        
        var dict:[String:Any]  = [:]
        dict[CodingKeys.uuid.stringValue] = self.uuid
        dict[CodingKeys.name.stringValue] = self.name
        dict[CodingKeys.alias.stringValue] = self.alias
        dict[CodingKeys.email.stringValue] = self.email
        dict[CodingKeys.phone.stringValue] = self.phone
        if self.messageToken != nil {dict[CodingKeys.messageToken.stringValue] = self.messageToken}
        return dict
        
    }
    
    private func refreshImage() -> Void {
        
        guard let url = self.imageUrl else {
            self.imageData = AppUtilities.shared.fallbackFromCache(name: self.uuid, extension: defaultImageFormat)
            return
        }
        
        AppDelegate.imageFromUrl(url: url) { (data, error) in
            
            guard error == nil else {return}
            self.imageData = data
            
        }
        
    }
}

extension Person: CustomStringConvertible {
    
    public var description: String {
        
        return "Customer [\(self.uuid): \(self.name ?? "NoName") {alias: \(self.alias ?? "NoAlias"), phone: \(self.phone ?? "NpPhone"), email: \(self.email ?? "NoEmail"), imageURL: \(self.imageUrl?.description ?? "NoUrl"), hasToken?: \(self.messageToken != nil)}]"
        
    }

}

extension Person: SipHashable {
    
    public func appendHashes(to hasher: inout SipHasher) {
        hasher.append(self.uuid)
        hasher.append(self.name)
        hasher.append(self.phone)
        hasher.append(self.email)
        hasher.append(self.alias)
        hasher.append(self.imageUrl)
        hasher.append(self.imageData)
    }
    
    public static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

}
