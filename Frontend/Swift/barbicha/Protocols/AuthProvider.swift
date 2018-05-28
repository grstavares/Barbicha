//
//  AuthProvider.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 24/05/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation

protocol AuthProvider {
    
    func loggedUser(completion: @escaping (_ userId: Person?, Error?) -> Void) -> Void
    func registerUser(person: Person, password: String, completion: @escaping (_ userId: Person?, Error?) -> Void) -> Void
    func authenticate(email: String, password: String, completion: @escaping (_ userId: Person?, Error?) -> Void) -> Void
    func signOut() -> Void
    
}
