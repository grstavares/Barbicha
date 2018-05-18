//
//  MainCollection.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 17/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
struct BarbershopCollection: ExposableAsCollection {
    
    var name: String
    var pitchLine: String?
    var image: Data?
    var itens: [Exposable]

    var mainLabel: String {return self.name}
    var detail: String? {return self.pitchLine}
    var moreDetail: String? {return nil}
    var cellImage: Data? {return self.image}
    var cellLabel: String? {return self.mainLabel}
    var reference: Exposable {return self}
    
}
