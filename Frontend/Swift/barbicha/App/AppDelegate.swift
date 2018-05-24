//
//  AppDelegate.swift
//  barbicha
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    public var window: UIWindow?
    public var coordinator: AppCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()

        var initialVC: UIViewController!
        if let barbershop = self.initialBarbershop() {
            
            debugPrint(barbershop)
            self.coordinator = AppCoordinator(with: barbershop)
            initialVC = coordinator.rootVC()
        
        } else { initialVC = self.criticalErrorVC() }

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialVC
        self.window?.makeKeyAndVisible()

        return true
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func initialBarbershop() -> Barbershop? {

        guard let data = AppUtilities.shared.fallbackFromCache(name: "barbershop", extension: "json") else {debugPrint("File has no Data");return  nil}
        
        let decoder = JSONDecoder()
        guard let parsed = try? decoder.decode(Barbershop.self, from: data) else {debugPrint("File could not be parsed in dcit");return nil}
        
        parsed.imageData = AppUtilities.shared.fallbackFromCache(name: parsed.uuid, extension: defaultImageFormat)
        parsed.barbers.forEach { $0.imageData = AppUtilities.shared.fallbackFromCache(name: $0.uuid, extension: "jpg")}
        
        return parsed
        
    }

    func criticalErrorVC() -> UIViewController {
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: "CriticalErrorVC")
        return vc
    }

}

let secondsInDay: Double = 1 * 24 * 60 * 60
let defaultImageFormat: String = "png"
