//
//  AppointmentCell.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 17/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import UIKit

class AppointmentCell: UITableViewCell {

    private var reference: ExposableAsAppointment?
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

    func configure(item: ExposableAsAppointment) -> Void {
        
        self.dateTime = item.startDate
        
        let start = AppUtilities.shared.formatDate(item.startDate, style: .onlyTime) ?? "NoTimeAvailable"
        let end = AppUtilities.shared.formatDate(item.startDate.addingTimeInterval(item.interval), style: .onlyTime)  ?? "NoTimeAvailable"
        let dateString: String = "\(start) - \(end)"
        
        self.mainLabel.text = dateString
        self.secondaryLabel.text = item.detail
        self.secondaryLabel.text = "\(item.startDate)"
        if item.serviceType != AppointmentType.empty && item.serviceType != AppointmentType.unavailable {self.reference = item}
        
        let backGrd = self.getBackground(cell: item)
        self.content.layer.backgroundColor = backGrd.cgColor
        
    }
    
    private func getBackground(cell: ExposableAsAppointment) -> UIColor {
        
        switch cell.serviceType {
        case .unavailable:return UIColor.init(patternImage: UIImage(named: "cellPattern")!).withAlphaComponent(0.5)
        case .empty:return UIColor.clear
        default : return AppColorPallete.shared.selectionColor
        }
        
    }
    
    
    public var referencedDateTime: Date {return self.dateTime}
    
    static func cellIdentifier() -> String {return AppDelegate.className(AppointmentCell.self)}
    
}
