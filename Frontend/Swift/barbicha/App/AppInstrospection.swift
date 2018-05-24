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

        let downloadImage = URLSession.shared.dataTask(with: url) {(data, response, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard data != nil else {
                completion(nil, nil)
                return

            }

            completion(data, nil)

        }
        
        downloadImage.resume()

    }
    
}


