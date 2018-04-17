//
//  Barbershop.swift
//  barbicha
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
import PlazazCore

public class Barbershop: PlazazOrganization {

    public var _uuid: String
    public var _name: String?
    public var _imageUrl: URL?
    public var _imageData: Data?
    private var _barbers = [Barber]()

    public var uuid: String {return self._uuid}
    public var name: String? { get {return self._name ?? ""} set {self._name = newValue} }
    public var imageUrl: URL? { get {return self._imageUrl } set {self._imageUrl = newValue} }
    public var imageData: Data? { get {return self._imageData} set {self._imageData = newValue} }
    public var barbers: [Barber] {return self._barbers}
    
    init(name: String, imageUrl: URL?) {
        
        self._uuid = PlazazCoreHelpers.newUUID(for: Barbershop.self)
        self._name = name
        self._imageUrl = imageUrl
        
        if imageUrl != nil {
            
            AppDelegate.imageFromUrl(url: imageUrl!) { (data, error) in
                
                guard error == nil else {return}
                self._imageData = data
                self.informChange(type: .imageChanged, object: self)
                
            }
            
        }
        
    }

    public func addBarber(_ barber: Barber) -> Void {
    
        self._barbers.append(barber)
        self.informChange(type: .itemAdded, object: self)
        
    }
    
    public func removeBarber(_ barber: Barber) -> Void {
        
        var i: Int = 0
        var toBeRemoved: Int? = nil
        for item in self._barbers {
            if item == barber {toBeRemoved = i}
            i = i + 1
        }
        
        if let found = toBeRemoved {
            self._barbers.remove(at: found)
            self.informChange(type: .itemRemoved, object: self)
        }

    }
    
    private func informChange(type: CollectionObservableEvent, object: Barbershop) -> Void {}
    
}

extension Barbershop: ExposableAsCollection {
    
    var image: Data? {return self._imageData}
    var mainLabel: String {return self._name ?? "EmptyName"}
    var detail: String? {return "Details"}
    var moreDetail: String? {return "MoreDetails"}
    var itens: [Exposable] {return self._barbers}
    
    var cellImage: Data? {return self.image}
    var cellLabel: String? {return self.mainLabel}
    var reference: Exposable {return self}

    
    var observableEvents: [Notification.Name] {
        
        let collectionEvents = [CollectionObservableEvent.collectionCleared.name, CollectionObservableEvent.itemAdded.name, CollectionObservableEvent.itemRemoved.name, CollectionObservableEvent.itemChangedOrder.name]
        let collectionItensEvents = [CollectionItemObservableEvent.itemRemoved.name, CollectionItemObservableEvent.itemUpdated.name]
        return collectionEvents + collectionItensEvents
        
    }
    
}
