//
//  BarbershopExtensions.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 23/05/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
import SipHash

extension Barbershop: CustomStringConvertible {
    
    var description: String {
        
        let location = self.location != nil ? "(\(self.location!.0.description), \(self.location!.1.description)" : "(0,0)"
        var desc: String = "Barbershop: [\n"
        desc.append("\(self.uuid)] \(self.name ?? "NoName"), Location: (\(location)")
        self.serviceTypes.forEach {desc.append("     \($0.description)")}
        self.barbers.forEach {desc.append("     \($0.description)")}
        return desc
        
    }
    
}

extension Barbershop: SipHashable {
    
    public func appendHashes(to hasher: inout SipHasher) {
        hasher.append(self.uuid)
        hasher.append(self.name)
        hasher.append(self.imageUrl)
        for item in self.serviceTypes.sorted(by: {$0.index < $1.index}) {hasher.append(item)}
        for item in self.barbers.sorted(by: {$0.uuid < $1.uuid}) {hasher.append(item)}
    }
    
    public static func == (lhs: Barbershop, rhs: Barbershop) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    
}

extension Barbershop: ExposableAsCollection {
    
    var image: Data? {return self.imageData}
    var mainLabel: String {return self.name ?? "EmptyName"}
    var detail: String? {return "Details"}
    var moreDetail: String? {return "MoreDetails"}
    var itens: [Exposable] {return self.barbers}
    
    var cellImage: Data? {return self.image}
    var cellLabel: String? {return self.mainLabel}
    var reference: Exposable {return self}
    
    var observableEvents: [Notification.Name] {
        
        let collectionEvents = [CollectionObservableEvent.collectionCleared.name, CollectionObservableEvent.itemAdded.name, CollectionObservableEvent.itemRemoved.name, CollectionObservableEvent.itemChangedOrder.name]
        let collectionItensEvents = [CollectionItemObservableEvent.itemRemoved.name, CollectionItemObservableEvent.itemUpdated.name]
        return collectionEvents + collectionItensEvents
        
    }
    
}
