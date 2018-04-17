//
//  Barber.swift
//  barbicha
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
import PlazazCore

public class Barber: PlazazPerson {
    
    public static func == (lhs: Barber, rhs: Barber) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    public var hashValue: Int {return 121345}
    
    
    public var _uuid: String
    public var _name: String?
    public var _imageUrl: URL?
    public var _imageData: Data?
    
    public var uuid: String {return self._uuid}
    public var name: String? { get {return self._name ?? ""} set {self._name = newValue} }
    public var imageUrl: URL? { get {return self._imageUrl } set {self._imageUrl = newValue} }
    public var imageData: Data? { get {return self._imageData} set {self._imageData = newValue} }
    
    init(name: String, imageUrl: URL?) {
        
        self._uuid = PlazazCoreHelpers.newUUID(for: Barber.self)
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
    
    private func informChange(type: CollectionItemObservableEvent, object: Barber) -> Void {}
    
}

extension Barber: Equatable, Hashable {}

extension Barber: ExposableAsDetails {
    
    var image: Data? {return self._imageData}
    var mainLabel: String {return self._name ?? ""}
    var detail: String? {return nil}
    var moreDetail: String? {return nil}

    var cellImage: Data? {return self.image}
    var cellLabel: String? {return self.mainLabel}
    var reference: Exposable {return self}
    
}
