//
//  Exposable.swift
//  barbicha
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
protocol Exposable {
    
    var cellImage: Data? { get }
    var cellLabel: String? { get }
    var reference: Exposable { get }
    var exposableType: TypeOfExposition { get }
    
}

public enum TypeOfExposition {
    
    case collection
    case detail
    
}
