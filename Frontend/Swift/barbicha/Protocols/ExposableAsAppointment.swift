//
//  ExposableAsAppointment.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 21/05/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
protocol ExposableAsAppointment {
    
    var startDate: Date { get }
    var interval: TimeInterval { get }
    var serviceType: Int { get }
    var detail: String? { get }
    
}
