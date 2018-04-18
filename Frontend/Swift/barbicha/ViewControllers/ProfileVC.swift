//
//  ProfileVC.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 17/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    private var coordinator: AppCoordinator!
    private var userData: UserData?

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

    static func instantiate(with userData: UserData?, using coordinator: AppCoordinator) -> ProfileVC? {
        
        let bundle = Bundle(for: self);
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        if let controller = storyboard.instantiateViewController(type: ProfileVC.self) {
            
            controller.coordinator = coordinator
            controller.userData = userData
            return controller
            
        } else {return nil}
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
    }

    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        self.view.bounds.size = CGSize(width: UIScreen.main.bounds.size.width - 50, height: 420)
        self.view.layer.cornerRadius = 10
        
    }
    
    func configView() {
        
        guard let data = self.userData else {return}
        
        self.textName.text = data.name
        self.textApelido.text = data.apelido
        self.textPhone.text = data.phone
        self.textEmail.text = data.email

        self.profileImageView.setImage(data.image)
        self.profileImageView.setBackgroundColor(UIColor.darkGray.withAlphaComponent(0.5))
        self.profileImageView.setBorderWidth(5)
        
    }
    
    @IBAction func buttonCancelClicked(_ sender: UIButton) {self.presentingViewController?.dismiss(animated: true, completion: nil)}
    @IBAction func buttonOkClicked(_ sender: UIButton) {}
    
}

struct UserData {
    
    var uuid: String?
    var name: String?
    var apelido: String?
    var phone: String?
    var email: String?
    var image: UIImage?
    
}

