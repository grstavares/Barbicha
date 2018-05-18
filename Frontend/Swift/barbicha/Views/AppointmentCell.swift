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
    private var dateTime: Date!
    
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
        
        self.dateTime = item.startDate
        
        let start = AppUtilities.shared.formatDate(item.startDate, style: .onlyTime) ?? "NoTimeAvailable"
        let end = AppUtilities.shared.formatDate(item.startDate.addingTimeInterval(item.interval), style: .onlyTime)  ?? "NoTimeAvailable"
        let dateString: String = "\(start) - \(end)"
        
        self.mainLabel.text = dateString
//        self.secondaryLabel.text = item.customerName
        self.secondaryLabel.text = "\(item.startDate)"
        if item.serviceType != AppointmentType.empty && item.serviceType != AppointmentType.unavailable {self.reference = item}
        
        let backGrd = item.serviceType == AppointmentType.unavailable ? UIColor.init(patternImage: UIImage(named: "cellPattern")!).withAlphaComponent(0.5) : item.serviceType != .empty ? AppColorPallete.shared.selectionColor : UIColor.clear
        self.content.layer.backgroundColor = backGrd.cgColor
        
    }
    
    public var referencedDateTime: Date {return self.dateTime}
    
    static func cellIdentifier() -> String {return AppDelegate.className(AppointmentCell.self)}
    
}
