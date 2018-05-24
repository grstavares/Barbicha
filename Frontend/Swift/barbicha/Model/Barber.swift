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

class Barber: Codable {

    public var uuid: String
    public var name: String?
    public var imageUrl: URL?
    public var imageData: Data?

    init(name: String, imageUrl: URL?) {
        
        let uuid = PlazazCoreHelpers.newUUID(for: Barber.self)
        self.uuid = uuid
        self.name = name
        self.imageUrl = imageUrl
        self.refreshImage()
        
    }

    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let _uuid = try values.decode(String.self, forKey: .uuid)
        let _name = try values.decode(String.self, forKey: .name)

        self.uuid = _uuid
        self.name = _name

        if let _url = try values.decodeIfPresent(String.self, forKey: .imageUrl), let url = URL(string: _url) {
            self.imageUrl = url
            self.refreshImage()
        }

    }
    
    public func updateValues(with newValues: Barber) -> Void {
        
        var changed = false
        if self.name != newValues.name {self.name = newValues.name; changed = true}
        if self.imageUrl != newValues.imageUrl {
            self.imageUrl = newValues.imageUrl;
            self.refreshImage()
        }
        
        if changed {self.signalChange(event: .barberUpdated)}
        
    }

    private func refreshImage() -> Void {
        
        guard let url = self.imageUrl else {
            self.imageData = AppUtilities.shared.fallbackFromCache(name: self.uuid, extension: defaultImageFormat)
            return
        }
        
        AppDelegate.imageFromUrl(url: url) { (data, error) in
            
            guard error == nil else {return}
            self.imageData = data
            self.signalChange(event: .barberImageUpdated)
            
        }
        
    }
    
}

extension Barber: CustomStringConvertible {
    
    var description: String {
        return "Barber [\(self.uuid): \(self.name ?? "NoName"), imageURL: \(self.imageUrl?.description ?? "NoUrl")}]"
    }
    
}

extension Barber: SipHashable {
    
    public func appendHashes(to hasher: inout SipHasher) {
        hasher.append(self.uuid)
        hasher.append(self.name)
        hasher.append(self.imageUrl)
//        hasher.append(self.imageData)
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
