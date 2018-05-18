//
//  AppointmentType.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 17/05/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
import SipHash

struct AppointmentType: Equatable, Codable {
    
    let index: Int
    let label: String
    let time: TimeInterval
    let isValidForChoice: Bool
    
    static let kEmptyTypeIndex:Int = -1
    static let kUnavailableTypeIndex: Int = -2
    
    static var empty: AppointmentType {return AppointmentType(index: AppointmentType.kEmptyTypeIndex, label: "", time: 30, isValidForChoice: false)}
    static var unavailable: AppointmentType {return AppointmentType(index: AppointmentType.kUnavailableTypeIndex, label: "", time: 30,  isValidForChoice: false)}
    
}

extension AppointmentType {
    
    init(index: Int, label: String, time: TimeInterval) {
        
        self.index = index
        self.label = label
        self.time = time
        self.isValidForChoice = true
        
    }
    
}

extension AppointmentType: SipHashable {
    
    func appendHashes(to hasher: inout SipHasher) {
        hasher.append(self.index)
        hasher.append(self.label)
        hasher.append(self.time)
        hasher.append(self.isValidForChoice)
    }

}
