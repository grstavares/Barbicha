//
//  AppointmentCell.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 17/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import UIKit

class AppointmentCell: UITableViewCell {

    private var reference: Appointment?
    
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var leftIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(item: Appointment) -> Void {
        
        let start = AppUtilities.shared.formatDate(item.startDate, style: .onlyTime) ?? "NoTimeAvailable"
        let end = AppUtilities.shared.formatDate(item.startDate.addingTimeInterval(item.interval), style: .onlyTime)  ?? "NoTimeAvailable"
        let dateString: String = "\(start) - \(end)"
        
        self.mainLabel.text = dateString
        self.secondaryLabel.text = item.customerName
        if item.serviceType != .empty && item.serviceType != .unavailable {self.reference = item}
        
        let backGrd = item.serviceType == .unavailable ? UIColor.init(patternImage: UIImage(named: "cellPattern")!) : item.serviceType != .empty ? UIColor.cyan : UIColor.clear
        self.content.layer.backgroundColor = backGrd.cgColor
        debugPrint("Background Color not Working -> \(item.serviceType) with \(backGrd.debugDescription)")
        
    }
    
    static func cellIdentifier() -> String {return AppDelegate.className(AppointmentCell.self)}
    
}
