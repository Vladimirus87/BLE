//
//  RegisterViewController.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 15.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class RegisterViewController: AccountViewController {
    
    @IBOutlet weak var buttonRegister: CAButton!
    @IBOutlet weak var buttonAgree: UIButton!
    @IBOutlet weak var agreeInfo: UILabel!
    @IBOutlet weak var whyMakeAcc: CAButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initWithData("Register")

    }
    
    override func dataValuesChecked(_ result : Bool!) {
        
        checkIsRegisterAvailable()
    }
    
    func checkIsRegisterAvailable() {
        
        var result = self.buttonAgree.isSelected
        
        for item in self.data {
            
            if let itemValue = item["value"] as? String {
                if itemValue.count == 0 {
                    result = false
                }
            }
        }
        
        self.buttonRegister.isAvailable = result
    }
    
    // MARK: - Actions
    
    @IBAction func buttonAgreePressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        checkIsRegisterAvailable()
    }
    
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func registerPressed(_ sender: CAButton) {
        
        checkInternet()

        var email: String?
        var pass: String?
        var repeatPass: String?

        for item in self.data {
            switch item["title"] as? String {
            case "email": email = item["value"] as? String
            case "password": pass = item["value"] as? String
            case "retype_password": repeatPass = item["value"] as? String
            default: break
            }
        }

        guard (email != nil), (pass != nil), (repeatPass != nil) else {
            return
        }

        guard pass == repeatPass else {
            self.alert(with: LS("ups"), message: LS("paswords_not_equal"), action: nil, comletion: nil)
            return
        }
        

        let user = CAUser(email: email!, password: pass!, repeatPassword: repeatPass!)
        
        let _ = AccountApi.shared.register(user: user, view: self.view) { (sucsess) in
            if sucsess {

                DispatchQueue.main.async {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController")
                    self.alert(with: LS("good"), message: LS("confirm_email"), action: nil, comletion: self.navigationController?.pushViewController(controller!, animated: true))
                }
            } else {
                self.alert(with: LS("ups"), message: LS("someth_went_wrong"), action: nil, comletion: nil)
            }
        }

    }
    
    
    
    
    // MARK: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}

