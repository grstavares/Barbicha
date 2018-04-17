//
//  ExposableAsCollection.swift
//  barbicha
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
protocol ExposableAsCollection: Exposable {
    
    var image: Data? { get }
    var mainLabel: String { get }
    var detail: String? { get }
    var moreDetail: String? { get }
    var itens: [Exposable] { get }
 
    var observableEvents: [Notification.Name] { get }
    
}

extension ExposableAsCollection {
    
    var exposableType: TypeOfExposition {return TypeOfExposition.collection}
    
    var observableEvents: [Notification.Name] {
        
        return [CollectionObservableEvent.collectionCleared.name,
                CollectionObservableEvent.itemAdded.name,
                CollectionObservableEvent.itemRemoved.name,
                CollectionObservableEvent.itemChangedOrder.name,
                CollectionObservableEvent.imageChanged.name]
        
    }
    
}

enum CollectionObservableEvent: String {
    case collectionCleared, itemAdded, itemRemoved, itemChangedOrder, imageChanged
    var name: Notification.Name {return Notification.Name(self.rawValue)}
}
