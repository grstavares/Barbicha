//
//  LoginVC.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 25/05/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    static func instantiate(using coordinator: AppCoordinator) -> LoginVC? {
        
        let bundle = Bundle(for: self);
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        if let controller = storyboard.instantiateViewController(type: LoginVC.self) {
            
            controller.coordinator = coordinator
            return controller
            
        } else {return nil}
        
    }
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var textEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var textSenha: SkyFloatingLabelTextField!
    @IBOutlet weak var buttonLogin: LoadingUIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    private var coordinator: AppCoordinator!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.configView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.modalView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        self.modalView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.3) {
            self.modalView.alpha = 1
            self.modalView.transform = CGAffineTransform.identity
        }
        
    }
    
    @IBAction func buttonLoginClicked(_ sender: Any) {
        
        self.textEmail.errorMessage = nil
        self.textSenha.errorMessage = nil
        
        guard let _email = self.textEmail.text else {
            
            self.textEmail.errorMessage = "Informe e e-mail!"
            return
            
        }
        
        guard let _senha = self.textSenha.text else {
            self.textSenha.errorMessage = "Informe a senha!"
            return
        }

        self.buttonLogin.showLoading()
        let action = AppAction.loginWithEmailAndPassword(_email, _senha)
        self.coordinator.performAction(from: self, action: action) { (success, error) in
            
            self.buttonLogin.hideLoading()
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
    
    @IBAction func buttonCancelClicked(_ sender: Any) {self.dismiss(animated: true, completion: nil)}
 
    func configView() -> Void {

        self.modalView.layer.cornerRadius = 15
        self.modalView.clipsToBounds = true
        self.buttonLogin.layer.cornerRadius = 10
        self.buttonCancel.layer.cornerRadius = 10
        self.buttonLogin.clipsToBounds = true
        
        self.textEmail.placeholder = "e-mail"
        self.textEmail.title = "e-mail"
        self.textSenha.placeholder = "Senha"
        self.textSenha.title = "Senha"
        
        [self.textEmail, self.textSenha].forEach {
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
    
}

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {nextField.becomeFirstResponder()
        } else {textField.resignFirstResponder()}
        
        return false
        
    }
    
}
