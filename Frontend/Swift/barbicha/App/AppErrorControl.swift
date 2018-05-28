//
//  AppErrorControl.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 25/05/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
enum AppError: Error {
    
    case authErrorInvalidData(String)
    case authErrorNotAutorized
    case authErrorProvider(String)
    
}
