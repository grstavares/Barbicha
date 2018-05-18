//
//  CollectionItemVC.swift
//  barbicha
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import UIKit
import PlazazCore

class CollectionItemVC: UIViewController {

    private var coordinator: AppCoordinator!
    private var barbershop: Barbershop!
    private var barber: Barber!
    private var appointments: [Appointment] = []
    private var selectedDate: Date!
    private var formatter: DateFormatter!
    
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerButtonOk: UIButton!
    @IBOutlet weak var datePickerButtonCancel: UIButton!

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
        self.configVC()
        self.registerCell()
        self.table.delegate = self
        self.table.dataSource = self
        self.configView()
        
    }
    
    private func registerCell() -> Void {
        
        let nib = UINib.init(nibName: AppointmentCell.cellIdentifier(), bundle: Bundle.main)
        self.table.register(nib, forCellReuseIdentifier: AppointmentCell.cellIdentifier())
        
    }
    
    private func configVC() -> Void {
        
        self.datePickerView.layer.cornerRadius = 10
        self.datePickerView.clipsToBounds = true
        
        self.datePicker.minimumDate = Date()
        self.datePicker.datePickerMode = .date
        
    }
    
    private func configView() -> Void {
        
        self.mainLabel.text = self.barber.name
        self.detailLabel.text = self.barber.detail
        
        self.profileView.setBorderWidth(5)
        if let image = barber.image, let uiImage = UIImage(data: image) { self.profileView.setImage(uiImage)}
        
        self.table.layer.cornerRadius = 10
        
        self.buttonDate.setTitle(formatter.string(from: self.selectedDate), for: UIControlState.normal)
        self.setControllerDate(date: self.selectedDate)
        
    }
    
    @IBAction func buttonBackClicked(_ sender: UIButton) {self.dismiss(animated: true, completion: nil)}
    @IBAction func buttonProfileClicked(_ sender: UIButton) {self.coordinator.performAction(from: self, action: .showProfile)}
    @IBAction func buttonPreviousClicked(_ sender: UIButton) {self.setControllerDate(appendingDays: -1)}
    @IBAction func buttonNextClicked(_ sender: UIButton) {self.setControllerDate(appendingDays: 1)}
    @IBAction func buttonDateClicked(_ sender: UIButton) {

        self.datePicker.setDate(self.selectedDate, animated: true)
        self.datePickerView.center = self.view.center
        self.view.addSubview(self.datePickerView)
        
    }
    
    @IBAction func buttondatePickerCancelClicked(_ sender: UIButton) {self.datePickerView.removeFromSuperview()}
    
    @IBAction func buttondatePickerOkClicked(_ sender: UIButton) {
        
        let newDate = self.datePicker.date
        self.setControllerDate(date: newDate)
        
    }
    
    @IBAction func buttonMessageClicked(_ sender: UIButton) {self.coordinator.performAction(from: self, action: .showLocation(self.barbershop))}
    @IBAction func buttonGalleryClicked(_ sender: UIButton) {self.coordinator.performAction(from: self, action: .showGallery)}

    private func setControllerDate(date: Date) -> Void {
        
        let activity: UIActivityIndicatorView = UIActivityIndicatorView()
        activity.center = self.buttonDate.center
        activity.hidesWhenStopped = true
        activity.activityIndicatorViewStyle = .gray
        self.view.addSubview(activity)
        
        activity.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        if self.selectedDate != date {
            
            self.appointments = self.barbershop.appointments(for: date, with: barber.uuid)
            self.table.reloadData()
            
            self.selectedDate = date
            self.buttonDate.setTitle(formatter.string(from: self.selectedDate), for: UIControlState.normal)

        }
        
        self.setVisibleCellforNow()

        activity.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
    }
    
    private func setControllerDate(appendingDays: Int) -> Void {
        
        let interval = TimeInterval(Double(appendingDays) * secondsInDay)
        let newDate = self.selectedDate.addingTimeInterval(interval)
        self.setControllerDate(date: newDate)
        
    }
    
    private func setVisibleCellforNow() -> Void {
        
        let now = Date()
        for i in 0...self.appointments.count - 1 {
            
            if now < self.appointments[i].startDate {
                
                let indexPath = IndexPath(row: i, section: 0)
                self.table.scrollToRow(at: indexPath, at: .top, animated: true)
                return}}
        
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

extension CollectionItemVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selected = self.appointments[indexPath.row]

        guard let customer = self.coordinator.loggedUser else {
            self.requestUserInfo()
            return
        }

        let isBarber = self.barber.uuid == customer.uuid
        if isBarber {self.barberSelectedAppointment(selected)
        } else {self.customerSelectedAppointment(selected, customer: customer)}

    }
    
    func requestUserInfo() -> Void {
        
        let alertTit = "Usuário não registrado!"
        let alertMsg = "Para realizar um agendamento, você deve informar alguns dados básicos, deseja continuar?"
        let alertCancel = "Cancelar"
        let alertOk = "OK"
        let alert = UIAlertController(title: alertTit, message: alertMsg, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: alertOk, style: .default) { (action) in alert.dismiss(animated: true, completion: {self.coordinator.performAction(from: self, action: .showProfile)})}
        let actionCancel = UIAlertAction(title: alertCancel, style: .cancel) { (action) in alert.dismiss(animated: true, completion: nil)}
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func barberSelectedAppointment(_ selected: Appointment) -> Void {
        
        if selected.isEmpty {self.requestConfirmationForSettingUnavailable(for: selected)
        } else {self.requestActionForSchedulledAppointment(for: selected)}
        
    }
    
    private func customerSelectedAppointment(_ selected: Appointment, customer: PlazazPerson) -> Void {
        
        if selected.isEmpty {self.requestServiceChoice(for: selected, customer: customer)
        } else {self.informUnavailability()}
        
    }

    func informUnavailability() -> Void {
        
        let alertTit = "Seleção Inválida"
        let alertMsg = "Horário não disponível para agendamento!"
        let okMsg = "OK"
        
        let alerta = UIAlertController(title: alertTit, message: alertMsg, preferredStyle: .alert)
        let cancel = UIAlertAction(title: okMsg, style: .cancel) { (action) in alerta.dismiss(animated: true, completion: nil)}
        alerta.addAction(cancel)
        
        self.present(alerta, animated: true, completion: nil)
        
    }
    
    private func requestConfirmationForSettingUnavailable(for appointment: Appointment) -> Void {
        
        let alertTit = "Bloqueio de Horário!"
        let alertMsg = "Deseja bloquear este horário?"
        let alertCancel = "Cancelar"
        let alertOk = "OK"
        
        let appAction = AppAction.confirmAppointment
        
        let alert = UIAlertController(title: alertTit, message: alertMsg, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: alertOk, style: .default) { (action) in alert.dismiss(animated: true, completion: {self.coordinator.performAction(from: self, action: appAction)})}
        let actionCancel = UIAlertAction(title: alertCancel, style: .cancel) { (action) in alert.dismiss(animated: true, completion: nil)}
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func requestActionForSchedulledAppointment(for appointment: Appointment) -> Void {
        
        let alertTit = "Horário Agendado!"
        let alertMsg = "O que deseja realizar com este horário agendado?"
        
        let actionTit: [String] = ["Confirmar Agendamento", "Mandar Mensagem", "Fazer Ligação", "Alterar Horário", "Finalizar Atendimento"]
        let appActions: [AppAction] = [AppAction.confirmAppointment, AppAction.confirmAppointment, AppAction.confirmAppointment, AppAction.confirmAppointment, AppAction.confirmAppointment]
        
        let alertFecharTit = "Fechar"

        let alert = UIAlertController(title: alertTit, message: alertMsg, preferredStyle: .alert)
        
        for i in 0...actionTit.count - 1 {
            
            let action = UIAlertAction(title: actionTit[i], style: .default) { (action) in self.coordinator.performAction(from: self, action: appActions[i])}
            alert.addAction(action)
            
        }
        
        let actionFechar = UIAlertAction(title: alertFecharTit, style: .cancel) { (action) in alert.dismiss(animated: true, completion: nil)}
        alert.addAction(actionFechar)

        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func requestServiceChoice(for appointment: Appointment, customer: PlazazPerson) -> Void {
        
        guard self.barbershop.serviceTypes.count > 0 else {
            
            let errorTit = "Erro"
            let errorMsg = "O Estabelecimento não oferece serviços nesta data!"
            let errorAlert = UIAlertController(title: errorTit, message: errorMsg, preferredStyle: .alert)
            let errorAction = UIAlertAction(title: "Fechar", style: .cancel) { (action) in errorAlert.dismiss(animated: true, completion: nil)}
            errorAlert.addAction(errorAction)
            self.present(errorAlert, animated: true, completion: nil)
            return
            
        }
        
        let alertTit = self.barbershop.name
        let alertMsg = "Selecione o Serviço Desejado!"
        
        let alerta = UIAlertController(title: alertTit, message: alertMsg, preferredStyle: .alert)
        
        var actions: [UIAlertAction] = []
        for serviceType in self.barbershop.serviceTypes {
            
            let action = UIAlertAction(title: serviceType.label, style: .default) { (action) in
                
                let appAction = AppAction.makeAppointment(self.barbershop, self.barber, appointment, serviceType, customer)
                self.coordinator.performAction(from: self, action: appAction)
                alerta.dismiss(animated: true, completion: nil)
                
            }
            
            actions.append(action)
            
        }
        
        actions.forEach { alerta.addAction($0)}
        
        let cancelTit = "Cancelar"
        alerta.addAction(UIAlertAction(title: cancelTit, style: .cancel) { (action) in alerta.dismiss(animated: true, completion: nil)})
        
        self.present(alerta, animated: true, completion: nil)
        
    }
    
}

















