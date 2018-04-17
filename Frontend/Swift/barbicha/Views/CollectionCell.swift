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
    private var reference: Exposable?
    
    public var objectRef: Exposable? {return self.reference}
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = self.contentView.layer.bounds.size.height / 2
        self.contentView.clipsToBounds = true
        
    }
    
    func configure(item: Exposable) -> Void {
        
        var uiImage: UIImage? = nil
        if let data = item.cellImage {uiImage = UIImage(data: data)}
        
        self.cellImage.image = uiImage
        self.cellLabel.text = item.cellLabel
        self.reference = item
        
    }

    static func cellIdentifier() -> String {return AppDelegate.className(CollectionCell.self)}
    
}
