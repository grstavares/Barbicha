//
//  ExposableAsDetails.swift
//  barbicha
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
protocol ExposableAsDetails: Exposable {
    
    var image: Data? { get }
    var mainLabel: String { get }
    var detail: String? { get }
    var moreDetail: String? { get }
    
    var observableEvents: [Notification.Name] { get }
    
}

extension ExposableAsDetails {
    
    var exposableType: TypeOfExposition {return TypeOfExposition.detail}
    
    var observableEvents: [Notification.Name] { return [CollectionItemObservableEvent.itemRemoved.name,
                                                        CollectionItemObservableEvent.itemUpdated.name,
                                                        CollectionItemObservableEvent.imageChanged.name]}
    
}

enum CollectionItemObservableEvent: String {
    case itemRemoved, itemUpdated, imageChanged
    var name: Notification.Name {return Notification.Name(self.rawValue)}
}
