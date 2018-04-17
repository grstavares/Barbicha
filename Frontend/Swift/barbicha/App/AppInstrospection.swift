//
//  GlobalFunctions.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 14/11/2017.
//  Copyright © 2017 Gustavo Tavares. All rights reserved.
//

import UIKit
extension AppDelegate {
	
	static func className(_ clazz:AnyClass) -> String {
		
		var fullName: String = NSStringFromClass(clazz.self)
		if let range = fullName.range(of: ".", options: .backwards) {
			fullName = String.init(fullName[range.upperBound...])
		}
		
		return fullName
		
	}

    static func imageFromUrl(url: URL, completion: @escaping (Data?, Error?) -> ()) -> Void {
        
//        DispatchQueue.main.async {
        
            do {
                
                let returned = try Data(contentsOf: url)
                completion(returned, nil)
                
            } catch {completion(nil, error)}
            
//        }
        
    }
    
}


