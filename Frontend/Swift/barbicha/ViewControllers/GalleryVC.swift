//
//  GalleryVC.swift
//  barbicha
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import UIKit

class GalleryVC: UIViewController {

    private var coordinator: AppCoordinator!
    
    @IBOutlet weak var buttonBack: UIButton!
    
    static func instantiate(using coordinator: AppCoordinator) -> GalleryVC? {
        
        let bundle = Bundle(for: self);
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        if let controller = storyboard.instantiateViewController(type: GalleryVC.self) {
            
            controller.coordinator = coordinator
            return controller
            
        } else {return nil}
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonBackClicked(_ sender: UIButton) {self.dismiss(animated: true, completion: nil)}
    
}
