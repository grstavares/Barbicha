//
//  CollectionCell.swift
//  barbicha
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    private var reference: Barber?
    
    public var objectRef: Barber? {return self.reference}
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = self.contentView.layer.bounds.size.height / 2
        self.contentView.clipsToBounds = true
        
    }
    
    func configure(item: Barber) -> Void {
        
        self.cellImage.image = nil
        self.cellLabel.text = nil
        
        var uiImage: UIImage? = nil
        if let data = item.imageData {uiImage = UIImage(data: data)} else {uiImage = UIImage(named: "placeholderPerson")}
        
        self.cellImage.image = uiImage
        self.cellLabel.text = item.name
        self.reference = item
        
    }

    static func cellIdentifier() -> String {return AppDelegate.className(CollectionCell.self)}
    
}
