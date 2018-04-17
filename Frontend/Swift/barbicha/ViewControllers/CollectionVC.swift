//
//  CollectionVC.swift
//  barbicha
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import UIKit

class CollectionVC: UIViewController {

    private var coordinator: AppCoordinator!
    private var presentedCollection: ExposableAsCollection!
    private var collectionItens = [Exposable]()
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var moreDetailLabel: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var buttonLocation: UIButton!
    @IBOutlet weak var buttonGallery: UIButton!
    
    static func instantiate(with collection: ExposableAsCollection, using coordinator: AppCoordinator) -> CollectionVC? {
        
        let bundle = Bundle(for: self);
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        if let controller = storyboard.instantiateViewController(type: CollectionVC.self) {
            
            controller.coordinator = coordinator
            controller.presentedCollection = collection
            controller.collectionItens = collection.itens
            return controller
            
        } else {return nil}
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.registerCell()
        self.collection.delegate = self
        self.collection.dataSource = self
        self.configView()
        
    }

    private func registerCell() -> Void {
        
        let nib = UINib.init(nibName: CollectionCell.cellIdentifier(), bundle: Bundle.main)
        self.collection.register(nib, forCellWithReuseIdentifier: CollectionCell.cellIdentifier())
        
    }
    
    private func configView() -> Void {
        
        self.mainLabel.text = presentedCollection.mainLabel
        self.detailLabel.text = presentedCollection.detail
        self.moreDetailLabel.text = presentedCollection.moreDetail
        if let image = presentedCollection.image, let uiImage = UIImage(data: image) { self.image.image = uiImage}
        
    }
    
    @IBAction func buttonLocationClicked(_ sender: UIButton) {self.coordinator.performAction(from: self, action: .showLocation)}
    @IBAction func buttonGalleryClicked(_ sender: UIButton) {self.coordinator.performAction(from: self, action: .showGallery)}
    
}

extension CollectionVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {return 1}
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {return self.collectionItens.count}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.cellIdentifier(), for: indexPath) as? CollectionCell else {return UICollectionViewCell()}
        
        let item = self.collectionItens[indexPath.item]
        cell.configure(item: item)
        return cell
        
    }
    
    
}

extension CollectionVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = collectionView.cellForItem(at: indexPath) as? CollectionCell else {return}
        guard let reference = item.objectRef else {return}
        
        switch reference.exposableType {
        case .collection:
            let newCollection = reference as! ExposableAsCollection
            self.coordinator.performAction(from: self, action: .showCollection(newCollection))
            
        case .detail:
            let detail = reference as! ExposableAsDetails
            self.coordinator.performAction(from: self, action: .showDetail(detail))
        }

    }
    
}
