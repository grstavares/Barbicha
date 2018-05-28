//
//  ProfileVC.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 17/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    private let sTitleLogout = "Sair"
    
    private var coordinator: AppCoordinator!
    private var loggedUser: Person?
    private var showingUser: Bool {return loggedUser != nil}
    private var modalSize: CGRect = CGRect.zero
    private var originalConstraintsForModal: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
    
    private var loginRect: CGRect {
        
        let height:CGFloat = 300
        let width:CGFloat = 240
        let x = (UIScreen.main.bounds.height - height) / 2
        let y = (UIScreen.main.bounds.width - width) / 2
        return CGRect(x: x, y: y, width: width, height: height)
        
    }
    
    private var center: CGPoint {
        let centerX = UIScreen.main.bounds.width / 2
        let centerY = UIScreen.main.bounds.height / 2
        return CGPoint(x: centerX, y: centerY)
    }
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var textName: SkyFloatingLabelTextField!
    @IBOutlet weak var textApelido: SkyFloatingLabelTextField!
    @IBOutlet weak var textPhone: SkyFloatingLabelTextField!
    @IBOutlet weak var textEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var textSenha: SkyFloatingLabelTextField!
    
    @IBOutlet weak var buttonStackHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonOk: LoadingUIButton!

    static func instantiate(with user: Person?, using coordinator: AppCoordinator) -> ProfileVC? {
        
        let bundle = Bundle(for: self);
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        if let controller = storyboard.instantiateViewController(type: ProfileVC.self) {
            
            controller.coordinator = coordinator
            controller.loggedUser = user
            return controller
            
        } else {return nil}
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.configVC()
        self.configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
 
        self.loggedUser = self.coordinator.loggedUser
        if loggedUser != nil {
            
            self.buttonLogin.removeFromSuperview()
            self.buttonStackHeight.constant = buttonStackHeight.constant / 2
            
            self.buttonOk.setTitle(sTitleLogout, for: .normal)
            self.buttonCancel.setTitle("Fechar", for: .normal)
            self.textSenha.removeFromSuperview()
        
            self.textName.text = loggedUser?.name
            self.textApelido.text = loggedUser?.alias
            self.textPhone.text = loggedUser?.phone
            self.textEmail.text = loggedUser?.email

        }
        
    }
    
    func configVC() {
        
        [self.textName, self.textEmail, self.textPhone, self.textApelido, self.textSenha].forEach { $0?.delegate = self }
        self.observeKeyboard()

    }
    
    func configView() {
        
        self.textName.placeholder = "Nome Completo"
        self.textName.title = "Nome Completo"
        self.textApelido.placeholder = "Apelido"
        self.textApelido.title = "Apelido (opcional)"
        self.textPhone.placeholder = "Telefone"
        self.textPhone.title = "Telefone"
        self.textEmail.placeholder = "e-mail"
        self.textEmail.title = "e-mail"
        self.textSenha.placeholder = "Senha"
        self.textSenha.title = "Senha"

        self.buttonLogin.layer.cornerRadius = 10
        self.buttonCancel.layer.cornerRadius = 10
        self.buttonOk.layer.cornerRadius = 10
        self.buttonLogin.clipsToBounds = true
        self.buttonCancel.clipsToBounds = true
        self.buttonOk.clipsToBounds = true

        [self.textName, self.textEmail, self.textPhone, self.textApelido, self.textSenha].forEach {
            $0?.delegate = self
            $0?.tintColor = UIColor.darkText
            $0?.placeholderColor = UIColor.darkGray
            $0?.textColor = UIColor.darkText
            $0?.lineColor = UIColor.darkText
            $0?.titleColor = UIColor.darkText
            $0?.errorColor = UIColor.red.withAlphaComponent(0.5)
            $0?.borderStyle = .none
        }

    }
    
    @IBAction func buttonBackClicked(_ sender: UIButton) {self.presentingViewController?.dismiss(animated: true, completion: nil)}
    @IBAction func buttonCancelClicked(_ sender: UIButton) {self.presentingViewController?.dismiss(animated: true, completion: nil)}
    @IBAction func buttonShowLogin(_ sender: UIButton) {self.coordinator.performAction(from: self, action: .showLogin)}
    
    @IBAction func buttonOkClicked(_ sender: UIButton) {

        guard self.buttonOk.title(for: .normal) != sTitleLogout else {
            
            self.coordinator.performAction(from: self, action: .logOut)
            self.dismiss(animated: true, completion: nil)
            return
            
        }
        
        self.textEmail.errorMessage = nil
        self.textPhone.errorMessage = nil
        
        let _name = self.textName.text
        let _alias = self.textApelido.text
        let _phone = self.textPhone.text
        let _email = self.textEmail.text
        let _passwrd = self.textSenha.text

        guard _email != nil, !_email!.isEmpty, AppDelegate.isValidEmail(value: _email!) else {
            self.textEmail.errorMessage = "E-mail Inválido!"
            return
        }

        guard _phone != nil, !_phone!.isEmpty, AppDelegate.isValidPhone(value: _phone!) else {
            self.textPhone.errorMessage = "Telefone Inválido!"
            return
        }

        let newPerson = Person(name: _name, alias: _alias, phone: _phone, email: _email)
        let action = AppAction.registerUser(newPerson, _passwrd!)
        
        self.buttonOk.showLoading()
        self.coordinator.performAction(from: self, action: action) { (success, error) in
            
            self.buttonOk.hideLoading()
            guard error == nil else {
                
                let alertVC = UIAlertController(title: "Erro", message: error?.localizedDescription, preferredStyle: .alert)
                let alertOk = UIAlertAction(title: "Ok", style: .default, handler: { (okTapped) in alertVC.dismiss(animated: true, completion: nil)})
                alertVC.addAction(alertOk)
                self.present(alertVC, animated: true, completion: nil)
                return
                
            }
            
            if success {self.dismiss(animated: true, completion: nil)
            } else {debugPrint("Not Success ->")}
            
        }
        
    }
    
    private func observeKeyboard() -> Void {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let adjustmentHeight = (keyboardFrame.height + 20) * (show ? 1 : -1)
        
        self.scrollView.contentInset.bottom += adjustmentHeight
        self.scrollView.scrollIndicatorInsets.bottom += adjustmentHeight
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustInsetForKeyboardShow(true, notification: notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustInsetForKeyboardShow(false, notification: notification)
    }
    
    let kTextPhoneTag = 7
    let kTextEmailTag = 8

}

extension ProfileVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == kTextPhoneTag, let text = textField.text, let customControl = textField as? SkyFloatingLabelTextField {
            if AppDelegate.isValidPhone(value: text) {customControl.errorMessage = nil} else {customControl.errorMessage = "Telefone Inválido!"}
        }
        
        if textField.tag == kTextEmailTag, let text = textField.text, let customControl = textField as? SkyFloatingLabelTextField {
            if AppDelegate.isValidEmail(value: text) {customControl.errorMessage = nil} else {customControl.errorMessage = "E-mail Inválido!"}
        }
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {nextField.becomeFirstResponder()
        } else {textField.resignFirstResponder()}
        
        return false
        
    }
    
}

