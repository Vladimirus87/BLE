//
//  SettingsManageAccountViewController.swift
//  CicloApp
//
//  Created by Владимир Моисеев on 17.04.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class SettingsManageAccountViewController: CAViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var logOut: CAButton!
    @IBOutlet weak var changePass: CAButton!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var account: UILabel!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if AccountApi.shared.accessToken != nil {
            logOut.setTitle("log out", for: .normal)
         } else {
            logOut.setTitle("log in", for: .normal)
            email.isHidden = true
            changePass.isHidden = true
            account.isHidden = true
        }
        
        email.text = AccountApi.shared.userEmail ?? ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changePassPressed(_ sender: CAButton) {
        
        AccountApi.shared.resetPassword(for: AccountApi.shared.userEmail ?? "", view: self.view) { (success) in
            if success {
                guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "StartViewController") as? StartViewController else { return }
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                self.alert(with: "Error!", message: nil, action: nil, comletion: nil)
            }
        }
        
        
    }
    
    
    @IBAction func logoutPressed(_ sender: CAButton) {
        AccountApi.shared.accessToken  = nil
        AccountApi.shared.refreshToken = nil
        AccountApi.shared.userId       = nil
        AccountApi.shared.userEmail    = nil
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func updateColorScheme() {
        super.updateColorScheme()
        
        self.background.backgroundColor = Config.shared.backgroundColor()
        self.titleView.backgroundColor = Config.shared.backgroundColor()
        self.titleText.textColor = Config.shared.titleColor()
        self.email.textColor = Config.shared.titleColor()
        self.changePass.layer.borderColor = Config.shared.titleColor().cgColor
        self.changePass.setTitleColor(Config.shared.titleColor(), for: .normal)
        self.back.tintColor = Config.shared.titleColor()
        self.logOut.tintColor = Config.shared.titleColor()
    }
    
    

}
