//
//  CollectionVC.swift
//  barbicha
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import UIKit

class BarbershopVC: UIViewController {

    private var coordinator: AppCoordinator!
    private var barbershop: Barbershop!
    private var barbers: [Barber] = []
    
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var moreDetailLabel: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var buttonProfile: UIButton!
    @IBOutlet weak var buttonLocation: UIButton!
    @IBOutlet weak var buttonGallery: UIButton!
    
    static func instantiate(_ barbershop: Barbershop, using coordinator: AppCoordinator) -> BarbershopVC? {
        
        let bundle = Bundle(for: self);
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        if let controller = storyboard.instantiateViewController(type: BarbershopVC.self) {
            
            controller.coordinator = coordinator
            controller.barbershop = barbershop
            controller.barbers = barbershop.barbers
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
        
        self.mainLabel.text = self.barbershop.mainLabel
        self.detailLabel.text = self.barbershop.detail
        self.moreDetailLabel.text = self.barbershop.moreDetail
        
        self.profileView.setBorderWidth(5)
        if let image = self.barbershop.image, let uiImage = UIImage(data: image) { self.profileView.setImage(uiImage)}
        
        let observers:[Barbershop.ObservableEvent] = [.shopUpdated, .imageUpdated, .barberListUpdated]
        let observersBarber: [Barber.ObservableEvent] = [.barberUpdated, .barberImageUpdated]
        self.registerObservers(observers: observers.map({ $0.notificationName }), selector: #selector(self.catchNotifications(notification:)))
        self.registerObservers(observers: observersBarber.map({ $0.notificationName }), selector: #selector(self.catchNotifications(notification:)))
        
    }
    
    @IBAction func buttonProfileClicked(_ sender: UIButton) {self.coordinator.performAction(from: self, action: .showProfile)}
    @IBAction func buttonLocationClicked(_ sender: UIButton) {self.coordinator.performAction(from: self, action: .showLocation(self.barbershop))}
    @IBAction func buttonGalleryClicked(_ sender: UIButton) {self.coordinator.performAction(from: self, action: .showGallery)}
    
    @objc private func catchNotifications(notification: Notification) -> Void {
        
        switch notification.name.rawValue {
            
        case Barbershop.ObservableEvent.shopUpdated.rawValue:
            
            self.mainLabel.text = self.barbershop.name
            
        case Barbershop.ObservableEvent.imageUpdated.rawValue:
            
            if let data = self.barbershop.imageData, let image = UIImage(data: data) {
                self.profileView.setImage(image)
            }

        case Barbershop.ObservableEvent.barberListUpdated.rawValue:

            DispatchQueue.main.async {
                self.barbers = self.barbershop.barbers
                self.collection.reloadData()
                let indexes = self.collection.indexPathsForVisibleItems
                self.collection.reloadItems(at: indexes)
            }

        case Barber.ObservableEvent.barberUpdated.rawValue, Barber.ObservableEvent.barberImageUpdated.rawValue:
            
            DispatchQueue.main.async {
                let indexes = self.collection.indexPathsForVisibleItems
                self.collection.reloadItems(at: indexes)
            }
            
        default:
            debugPrint(notification.name)
        }
        
    }
    
}

extension BarbershopVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {return 1}
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {return self.barbers.count}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.cellIdentifier(), for: indexPath) as? CollectionCell else {return UICollectionViewCell()}
        
        let item = self.barbers[indexPath.item]
        cell.configure(item: item)
        return cell
        
    }
    
    
}

extension BarbershopVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selected = self.barbers[indexPath.row]
        self.coordinator.performAction(from: self, action: .showBarber(self.barbershop, selected))

    }
    
}
