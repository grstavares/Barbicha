//
//  AppFirebaseConfiguration.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 27/05/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import Foundation
import Firebase
import FirebaseMessaging

extension AppDelegate: MessagingDelegate {
    
    func configureApp() {

        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true

    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {

        self.messageToken = fcmToken

    }
    
}
