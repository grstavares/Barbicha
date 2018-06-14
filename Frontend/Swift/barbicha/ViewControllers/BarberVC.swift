//
//  CollectionItemVC.swift
//  barbicha
//
//  Created by Gustavo Tavares on 16/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import UIKit

class BarberVC: UIViewController {

    private var coordinator: AppCoordinator!
    private var barbershop: Barbershop!
    private var barber: Barber!
    private var appointments: [Appointment] = []
    private var formatter: DateFormatter!
    private var selectedDate: Date!
    
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerButtonOk: UIButton!
    @IBOutlet weak var datePickerButtonCancel: UIButton!

    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet var profileViewTapRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonProfile: UIButton!
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonDate: LoadingUIButton!
    
    @IBOutlet weak var buttonMessage: UIButton!
    @IBOutlet weak var buttonGallery: UIButton!
    
    private var barberIsUsing: Bool {return self.barber.uuid == self.coordinator.loggedUser?.uuid}
    
    private let emptyCellColor: UIColor = UIColor.white.withAlphaComponent(0.3)
    private let occupiedCellColor: UIColor = UIColor.darkGray.withAlphaComponent(0.3)
    private let destakCellCollor: UIColor = UIColor.blue.withAlphaComponent(0.3)
    
    static func instantiate(with barbershop: Barbershop, and barber: Barber, using coordinator: AppCoordinator) -> BarberVC? {
        
        let bundle = Bundle(for: self);
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        if let controller = storyboard.instantiateViewController(type: BarberVC.self) {
            
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
        
        let shopObservers:[Barbershop.ObservableEvent] = [.appointmentListUpdated]
        self.registerObservers(observers: shopObservers.map({ $0.notificationName }), selector: #selector(self.catchBarberNotifications(notification:)))
        
        let appObservers:[Appointment.ObservableEvent] = [.statusUpdated, .dateUpdated, .infoUpdated]
        self.registerObservers(observers: appObservers.map({ $0.notificationName }), selector: #selector(self.catchBarberNotifications(notification:)))
        
    }
    
    private func configView() -> Void {
        
        self.mainLabel.text = self.barber.name
        self.detailLabel.text = self.barber.detail
        
        self.buttonDate.layer.cornerRadius = 15
        self.buttonDate.clipsToBounds = true
        
        self.profileView.setBorderWidth(5)
        if let image = barber.image, let uiImage = UIImage(data: image) { self.profileView.setImage(uiImage)}
        
        self.table.layer.cornerRadius = 10
        
        self.buttonDate.setTitle(formatter.string(from: self.selectedDate), for: UIControlState.normal)
        self.setControllerDate(date: self.selectedDate)
        
    }
    
    @IBAction func profileViewTapped(_ sender: Any) { }
    
    @IBAction func buttonBackClicked(_ sender: UIButton) {self.dismiss(animated: true, completion: nil)}
    
    @IBAction func buttonProfileClicked(_ sender: UIButton) { self.coordinator.performAction(from: self, action: AppAction.showProfile)}
    
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
        self.datePickerView.removeFromSuperview()
        self.setControllerDate(date: newDate)
        
    }
    
    @IBAction func buttonMessageClicked(_ sender: UIButton) {self.coordinator.performAction(from: self, action: .showLocation(self.barbershop))}
    
    @IBAction func buttonGalleryClicked(_ sender: UIButton) {self.coordinator.performAction(from: self, action: .showGallery)}

    private func setControllerDate(date: Date) -> Void {

        UIApplication.shared.beginIgnoringInteractionEvents()
        
        self.buttonDate.showLoading()
        if  Calendar.current.compare(self.selectedDate, to: date, toGranularity: .day) != .orderedSame {
            
            self.selectedDate = date
            self.appointments = self.barbershop.appointments(for: date, with: barber.uuid)
            self.table.reloadData()
            self.buttonDate.setTitle(formatter.string(from: self.selectedDate), for: UIControlState.normal)
            self.buttonDate.setNeedsDisplay()

        }
        
        self.setVisibleCellforNow()
        self.buttonDate.hideLoading()
        
        UIApplication.shared.endIgnoringInteractionEvents()
        
    }
    
    private func setControllerDate(appendingDays: Int) -> Void {
        
        if appendingDays < 0, Calendar.current.compare(self.selectedDate, to: Date(), toGranularity: .day) == .orderedSame {

            let alertTit = "Seleção Inválida"
            let alertMsg = "O agendamento não pode ser realizaado para datas antes de hoje!"
            let alertOk = "OK"
            let alert = UIAlertController(title: alertTit, message: alertMsg, preferredStyle: .alert)
            let actionOk = UIAlertAction(title: alertOk, style: .default) { _ in alert.dismiss(animated: true, completion: nil) }
            alert.addAction(actionOk)
            self.present(alert, animated: true, completion: nil)
            
        }
        
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

    @objc private func catchBarberNotifications(notification: Notification) -> Void {
        
        switch notification.name.rawValue {
        
        case Barbershop.ObservableEvent.appointmentListUpdated.rawValue:
            
            let newAppointments = self.barbershop.appointments(for: self.selectedDate, with: self.barber.uuid)
            var changedAndVisible: [IndexPath] = []
            
            for i in 0...self.appointments.count - 1 {
                
                let old = self.appointments[i]
                if i < newAppointments.count {
                    let new = newAppointments[i]
                    if old != new {
                        
                        self.appointments[i] = new
                        let indexPath = IndexPath(row: i, section: 0)
                        if let visible = self.table.indexPathsForVisibleRows {
                            if visible.contains(indexPath) {changedAndVisible.append(indexPath)}
                        }
                        
                    }
                }

            }
            
            if changedAndVisible.count > 0 {
                DispatchQueue.main.async { self.table.reloadRows(at: changedAndVisible, with: .fade)}
            }

        default:
            debugPrint(notification.name)
        }

    }
    
}

extension BarberVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {return 1}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return self.appointments.count}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppointmentCell.cellIdentifier()) as? AppointmentCell else {return UITableViewCell()}
        
        let item = self.appointments[indexPath.row]
        self.configureCell(cell: cell, with: item)
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    private func configureCell(cell: AppointmentCell, with item: Appointment) -> Void {

        let start = AppUtilities.shared.formatDate(item.startDate, style: .onlyTime) ?? "NoTimeAvailable"
        let end = AppUtilities.shared.formatDate(item.startDate.addingTimeInterval(Double(item.interval * 60)), style: .onlyTime)  ?? "NoTimeAvailable"
        let dateString: String = "\(start) - \(end)"
        let color = item.isEmpty ? self.emptyCellColor : self.coordinator.loggedUser?.uuid == item.customerUUID ? self.destakCellCollor : self.occupiedCellColor
        
        cell.content.backgroundColor = color
        cell.mainLabel.text = dateString
        cell.secondaryLabel?.text = self.barberIsUsing ? item.customerName : nil
        
    }
    
}

extension BarberVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selected = self.appointments[indexPath.row]

        guard let customer = self.coordinator.loggedUser else {
            self.requestUserInfo()
            return
        }

        if self.barberIsUsing {self.barberSelectedAppointment(selected)
        } else {self.customerSelectedAppointment(selected, customer: customer)}

    }
    
    func requestUserInfo() -> Void {
        
        let alertTit = "Usuário não registrado!"
        let alertMsg = "Para realizar um agendamento, você deve informar alguns dados básicos, deseja continuar?"
        let alertCancel = "Cancelar"
        let alertOk = "OK"
        let alert = UIAlertController(title: alertTit, message: alertMsg, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: alertOk, style: .default) { (alertAction) in
            DispatchQueue.main.async {self.coordinator.performAction(from: self, action: .showProfile)}
        }
        
        let actionCancel = UIAlertAction(title: alertCancel, style: .cancel) { (action) in alert.dismiss(animated: true, completion: nil)}
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func barberSelectedAppointment(_ selected: Appointment) -> Void {
        
        if selected.isEmpty {self.requestConfirmationForSettingUnavailable(for: selected)
        } else {self.requestBarberActionForSchedulledAppointment(for: selected)}
        
    }
    
    private func customerSelectedAppointment(_ selected: Appointment, customer: Person) -> Void {
        
        if selected.isEmpty {self.requestServiceChoice(for: selected, customer: customer)
        } else {
            
            if selected.customerUUID == customer.uuid {self.requestCustomerActionForSchedulledAppointment(for: selected)
            } else {self.informUnavailability()}
            
        }
        
    }

    private func informUnavailability() -> Void {
        
        let alertTit = "Seleção Inválida"
        let alertMsg = "Horário não disponível para agendamento!"
        let okMsg = "OK"
        
        let alerta = UIAlertController(title: alertTit, message: alertMsg, preferredStyle: .alert)
        let cancel = UIAlertAction(title: okMsg, style: .cancel) { (action) in alerta.dismiss(animated: true, completion: nil)}
        alerta.addAction(cancel)
        
        self.present(alerta, animated: true, completion: nil)
        
    }
    
    private func requestConfirmationForSettingUnavailable(for appointment: Appointment) -> Void {
        
        guard appointment.startDate.addingTimeInterval(Double(appointment.interval * 60)) >= Date() else {
            
            let errorTit = "Erro"
            let errorMsg = "Não é possível indicar atividades no passado!"
            let errorAlert = UIAlertController(title: errorTit, message: errorMsg, preferredStyle: .alert)
            let errorAction = UIAlertAction(title: "Fechar", style: .cancel) { (action) in errorAlert.dismiss(animated: true, completion: nil)}
            errorAlert.addAction(errorAction)
            self.present(errorAlert, animated: true, completion: nil)
            return
            
        }
        
        let alertTit = "Bloqueio de Horário!"
        let alertMsg = "Deseja bloquear este horário?"
        let alertCancel = "Cancelar"
        let alertOk = "OK"
        
        let appAction = AppAction.blockAppointment(appointment)
        
        let alert = UIAlertController(title: alertTit, message: alertMsg, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: alertOk, style: .default) { (action) in alert.dismiss(animated: true, completion: {self.coordinator.performAction(from: self, action: appAction)})}
        let actionCancel = UIAlertAction(title: alertCancel, style: .cancel) { (action) in alert.dismiss(animated: true, completion: nil)}
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func requestCustomerActionForSchedulledAppointment(for appointment: Appointment) -> Void {
        
        let alertTit = "Horário Agendado!"
        let alertMsg = "O que deseja realizar com este horário agendado?"
        
        let actionTit: [String] = ["Cancelar Agendamento", "Alterar Horário", "Avaliar Atendimento"]
        let appActions: [AppAction] = [AppAction.cancelAppointment(appointment), AppAction.requestChange(appointment), AppAction.endAppointment(appointment)]
        
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
    
    private func requestBarberActionForSchedulledAppointment(for appointment: Appointment) -> Void {
        
        let alertTit = "Horário Agendado!"
        let alertMsg = "O que deseja realizar com este horário agendado?"
        
        var titles: [String] = ["Alterar Horário"]
        var actions: [AppAction] = [AppAction.requestChange(appointment)]
        
        if let customerUUID = appointment.customerUUID, let customer = self.coordinator.customerInfo(uuid: customerUUID) {
            
            titles.append("Fazer Ligação")
            actions.append(AppAction.makeCall(customer))
            
//            titles.append("Mandar Mensagem")
//            actions.append(AppAction.sendMessage(self.barber, customer))
            
        }

        let alertFecharTit = "Fechar"

        let alert = UIAlertController(title: alertTit, message: alertMsg, preferredStyle: .alert)
        
        for i in 0...titles.count - 1 {
            
            let action = UIAlertAction(title: titles[i], style: .default) { (action) in self.coordinator.performAction(from: self, action: actions[i])}
            alert.addAction(action)
            
        }
        
        let actionFechar = UIAlertAction(title: alertFecharTit, style: .cancel) { (action) in alert.dismiss(animated: true, completion: nil)}
        alert.addAction(actionFechar)

        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func requestServiceChoice(for appointment: Appointment, customer: Person) -> Void {
        
        let minimumTimeInMinutes:Int = 15
        let minimumInterval: Double = Double(minimumTimeInMinutes) * 60
        guard appointment.startDate >= Date().addingTimeInterval(minimumInterval) else {
            
            let errorTit = "Erro"
            let errorMsg = "Somente é possível agendar atendimentos com o mínimo de \(minimumTimeInMinutes) minutos antes do horário solicitado!"
            let errorAlert = UIAlertController(title: errorTit, message: errorMsg, preferredStyle: .alert)
            let errorAction = UIAlertAction(title: "Fechar", style: .cancel) { (action) in errorAlert.dismiss(animated: true, completion: nil)}
            errorAlert.addAction(errorAction)
            self.present(errorAlert, animated: true, completion: nil)
            return

        }
        
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
                
                (UIApplication.shared.delegate as! AppDelegate).requestAPNAuth()
                let appAction = AppAction.requestAppointment(self.barbershop, self.barber, appointment, serviceType, customer)
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

