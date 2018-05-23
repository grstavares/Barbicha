//
//  UserPool.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 21/05/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
import PlazazCore

class UserPool: UserProvider {
    
    public static let shared = UserPool()
    
    private var secrets: [String:String] = [:]
    private var pool: [String: PlazazUser] = [:]
    
    func getUserInfo(uuid: String) -> PlazazUser? {
        return self.pool[uuid]
    }
    
    func getUserInfo(username: String) -> PlazazUser? {
        return self.pool[username]
    }
    
    func registerNewUser(_ user: PlazazUser, password: String, completion: @escaping (Bool, PlazazUser?, Error?) -> ()) {
        
        self.pool[user.uuid] = user
        self.secrets[user.uuid] = password
        completion(true, user, nil)
        
    }
    
    func authenticate(user: PlazazUser, password: String, completion: @escaping (Bool, PlazazUser?, Error?) -> ()) {
        
        guard let existentUsr = self.pool[user.uuid] else {completion(false, nil, nil); return}
        guard let existentPwd = self.secrets[user.uuid] else {completion(false, nil, nil); return}
        
        if password == existentPwd {completion(true, existentUsr, nil)
        } else {completion(false, nil, nil)}
        
    }
    
    func authenticate(username: String, password: String, completion: @escaping (Bool, PlazazUser?, Error?) -> ()) {

        let users = self.pool.values.filter({ $0.username == username })
        if users.count == 0 {completion(false, nil, nil); return}

        let user = users[0]
        guard let existentPwd = self.secrets[user.uuid] else {completion(false, nil, nil); return}

        if password == existentPwd {completion(true, user, nil)
        } else {completion(false, nil, nil)}
    
    }

}
