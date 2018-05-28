//
//  FireAuthProvider.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 24/05/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
import FirebaseAuth
import CodableFirebase

class FireAuthProvider: AuthProvider {
    
    let dataProvider: DataProvider
    
    public init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }
    
    private let personsPath:String = "persons/"

    public func loggedUser(completion: @escaping (_ userId: Person?, Error?) -> Void) -> Void {

        if let userId = Auth.auth().currentUser?.uid {self.getPerson(userId: userId, completion: completion)
        } else {completion(nil, nil)}

    }
    
    func registerUser(person: Person, password: String, completion: @escaping (_ userId: Person?, Error?) -> Void) -> Void {
        
        guard let email = person.email else {
            completion(nil, AppError.authErrorInvalidData("e-mail is nil"))
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard result != nil else {
                completion(nil, nil)
                return
            }
            
            let userId = result!.user.uid
            let newPerson = Person(uuid: userId, name: person.name, alias: person.alias, phone: person.phone, email: person.email)
            self.dataProvider.savePerson(newPerson, completion: { (success, error) in
                
                if error == nil {if success {completion(newPerson, nil)} else {completion(nil, nil)}
                } else {completion(nil, error)}
                
            })
            
        }
        
    }

    func authenticate(email: String, password: String, completion: @escaping (_ userId: Person?, Error?) -> Void) -> Void {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard result != nil else {
                completion(nil, nil)
                return
            }
            
            let userId = result!.user.uid
            self.getPerson(userId: userId, completion: completion)

        }
        
    }
    
    func signOut() -> Void {
        
        do {try Auth.auth().signOut()
        } catch {debugPrint(error)}
        
    }
    
    private func getPerson(userId: String, completion: @escaping (Person?, Error?) -> ()) -> Void {
        
        self.dataProvider.getPerson(uuid: userId, completion: { (person, error) in
            completion(person, error)
        })
        
    }
    
}
