//
//  ProfileVC.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 17/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import UIKit
import PlazazCore

class ProfileVC: UIViewController {

    private var coordinator: AppCoordinator!
    private var loggedUser: PlazazPerson?
    private var modalSize: CGRect = CGRect.zero
    private var originalConstraints: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var modalViewTopContraint: NSLayoutConstraint!
    @IBOutlet weak var modalViewBottonContraint: NSLayoutConstraint!
    @IBOutlet weak var modalViewLeadConstraint: NSLayoutConstraint!
    @IBOutlet weak var modalViewTrailConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var profileImageView: ProfileView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelApelido: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textApelido: UITextField!
    @IBOutlet weak var textPhone: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonOk: UIButton!

    static func instantiate(with user: PlazazPerson?, using coordinator: AppCoordinator) -> ProfileVC? {
        
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
    
    func configVC() {
        
        [self.textName, self.textEmail, self.textPhone, self.textApelido].forEach { $0?.delegate = self }
        
        self.modalSize = self.modalView.bounds
        self.originalConstraints = (self.modalViewTopContraint.constant, self.modalViewLeadConstraint.constant, self.modalViewBottonContraint.constant, self.modalViewTrailConstraint.constant )

        self.observeKeyboard()

    }
    
    func configView() {

        self.modalView.clipsToBounds = true
        self.modalView.layer.cornerRadius = 15
        
        self.textName.text = loggedUser?.name
        self.textApelido.text = loggedUser?.alias
        self.textPhone.text = loggedUser?.phone
        self.textEmail.text = loggedUser?.email

        if let data = loggedUser?.imageData, let image = UIImage(data: data) {
            self.profileImageView.setImage(image)
        } else {
            let image = UIImage(named: "iconProfile")!
            self.profileImageView.setImage(image)
        }

        self.profileImageView.setBackgroundColor(UIColor.darkGray.withAlphaComponent(0.5))
        self.profileImageView.setBorderWidth(5)

    }
    
    @IBAction func buttonCancelClicked(_ sender: UIButton) {self.presentingViewController?.dismiss(animated: true, completion: nil)}
    @IBAction func buttonOkClicked(_ sender: UIButton) {}
    
    private func observeKeyboard() -> Void {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc private func keyboardWillShow(notification: Notification) -> Void {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {

            UIView.animate(withDuration: 0.3) {
                
                self.profileImageView.alpha = 0
                self.modalViewTopContraint.constant = 10
                self.modalViewBottonContraint.constant = keyboardSize.height + 25
                
            }
            
        } else {debugPrint("No Keyboard Info")}

    }
    
    @objc private func keyboardWillHide(notification: Notification) -> Void {
        
        let top = self.originalConstraints.0
        let bot = self.originalConstraints.2
        
        UIView.animate(withDuration: 0.5) {
            self.profileImageView.alpha = 1
            self.modalViewTopContraint.constant = top
            self.modalViewBottonContraint.constant = bot
        }
        
    }
    
}

extension ProfileVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {nextField.becomeFirstResponder()
        } else {textField.resignFirstResponder()}
        
        return false
        
    }
    
}

