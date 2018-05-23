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
    let minutes: Int
    
    var time: TimeInterval {return Double(self.minutes) * 60}
    
    static let kEmptyTypeIndex:Int = -1
    static let kUnavailableTypeIndex: Int = -2
    
    static var empty: AppointmentType {return AppointmentType(index: AppointmentType.kEmptyTypeIndex, label: "", minutes: 30)}
    static var unavailable: AppointmentType {return AppointmentType(index: AppointmentType.kUnavailableTypeIndex, label: "", minutes: 30)}
    
}

extension AppointmentType: CustomStringConvertible {
    
    var description: String {
        return "AppointmentType [\(self.index) - \(self.label), \(self.time) ]"
    }
    
    
}

extension AppointmentType: SipHashable {
    
    func appendHashes(to hasher: inout SipHasher) {
        hasher.append(self.index)
        hasher.append(self.label)
        hasher.append(self.minutes)
    }

}
