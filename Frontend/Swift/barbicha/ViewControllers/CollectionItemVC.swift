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
    private var barbershop: Barbershop!
    private var barber: Barber!
    private var appointments: [Appointment] = []
    private var selectedDate: Date!
    private var formatter: DateFormatter!
    
    
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonProfile: UIButton!
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonDate: UIButton!
    
    @IBOutlet weak var buttonMessage: UIButton!
    @IBOutlet weak var buttonGallery: UIButton!
    
    static func instantiate(with barbershop: Barbershop, and barber: Barber, using coordinator: AppCoordinator) -> CollectionItemVC? {
        
        let bundle = Bundle(for: self);
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        if let controller = storyboard.instantiateViewController(type: CollectionItemVC.self) {
            
            controller.coordinator = coordinator
            controller.barbershop = barbershop
            controller.barber = barber
            controller.selectedDate = Date()
            controller.appointments = barbershop.appointments(for: Date(), with: barber.uuid)
            
            controller.formatter = DateFormatter()
            controller.formatter.timeZone = Calendar.current.timeZone
            controller.formatter.dateStyle = .medium
            controller.formatter.timeStyle = .none
            
            return controller
            
        } else {return nil}
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.registerCell()
        self.table.delegate = self
        self.table.dataSource = self
        self.configView()
        
    }
    
    private func registerCell() -> Void {
        
        let nib = UINib.init(nibName: AppointmentCell.cellIdentifier(), bundle: Bundle.main)
        self.table.register(nib, forCellReuseIdentifier: AppointmentCell.cellIdentifier())
        
    }
    
    private func configView() -> Void {
        
        self.mainLabel.text = self.barber.name
        self.detailLabel.text = self.barber.detail
        
        self.profileView.setBorderWidth(5)
        if let image = barber.image, let uiImage = UIImage(data: image) { self.profileView.setImage(uiImage)}
        
        self.table.layer.cornerRadius = 10
        self.setControllerDate(date: self.selectedDate)
        
    }
    
    @IBAction func buttonBackClicked(_ sender: UIButton) {self.dismiss(animated: true, completion: nil)}
    @IBAction func buttonProfileClicked(_ sender: UIButton) {self.coordinator.performAction(from: self, action: .showProfile(sender))}
    @IBAction func buttonPreviousClicked(_ sender: UIButton) {self.setControllerDate(appendingDays: -1)}
    @IBAction func buttonNextClicked(_ sender: UIButton) {self.setControllerDate(appendingDays: 1)}
    @IBAction func buttonDateClicked(_ sender: UIButton) {}
    @IBAction func buttonMessageClicked(_ sender: UIButton) {self.coordinator.performAction(from: self, action: .showLocation)}
    @IBAction func buttonGalleryClicked(_ sender: UIButton) {self.coordinator.performAction(from: self, action: .showGallery)}

    private func setControllerDate(date: Date) -> Void {
        
        self.selectedDate = date
        self.buttonDate.setTitle(formatter.string(from: self.selectedDate), for: UIControlState.normal)
        
    }
    
    private func setControllerDate(appendingDays: Int) -> Void {
        
        let interval = TimeInterval(Double(appendingDays) * secondsInDay)
        let newDate = self.selectedDate.addingTimeInterval(interval)
        self.setControllerDate(date: newDate)
        
    }
    
}

extension CollectionItemVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {return 1}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return self.appointments.count}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppointmentCell.cellIdentifier()) as? AppointmentCell else {return UITableViewCell()}
        
        let item = self.appointments[indexPath.row]
        cell.configure(item: item)
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension CollectionItemVC: UITableViewDelegate {}
