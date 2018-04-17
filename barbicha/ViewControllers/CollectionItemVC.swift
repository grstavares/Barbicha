//
//  CollectionItemVC.swift
//  barbicha
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import UIKit

class CollectionItemVC: UIViewController {

    private var coordinator: AppCoordinator!
    private var detailedItem: ExposableAsDetails!
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var mainLabel: UILabel!
    
    static func instantiate(with collectionItem: ExposableAsDetails, using coordinator: AppCoordinator) -> CollectionItemVC? {
        
        let bundle = Bundle(for: self);
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        if let controller = storyboard.instantiateViewController(type: CollectionItemVC.self) {
            
            controller.coordinator = coordinator
            controller.detailedItem = collectionItem
            return controller
            
        } else {return nil}
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configView() -> Void {
        
        self.mainLabel.text = detailedItem.mainLabel
//        self.detailLabel.text = detailedItem.detail
//        self.moreDetailLabel.text = detailedItem.moreDetail
//        if let image = detailedItem.image, let uiImage = UIImage(data: image) { self.image.image = uiImage}
        
    }
    
    @IBAction func buttonBackClicked(_ sender: UIButton) {self.dismiss(animated: true, completion: nil)}

}
