//
//  SignInViewController.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 15.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit
import Crashlytics


class SignInViewController: AccountViewController {

    @IBOutlet weak var buttonSignIn: CAButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initWithData("SignIn")

    }
    


    
    override func dataValuesChecked(_ result : Bool!) {
        self.buttonSignIn.isAvailable = result
    }
    
    // MARK: - Actions
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func SignInPressed(_ sender: CAButton) {
        
        checkInternet()
        
        var login: String?
        var pass: String?
        
        for item in self.data {
            switch item["title"] as? String {
            case "email": login = item["value"] as? String
            case "password": pass = item["value"] as? String
            default: break
            }
        }
        
        guard (login != nil), (pass != nil) else {
            return
        }
        
        let user = CAUser(login: login!, password: pass!)
        
        
        AccountApi.shared.getToken(user: user, view: self.view, completion: { autorise in
            
            if autorise {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "ShowMainTabs", sender: SignInViewController.self)
                }
            } else {
                self.alert(with: LS("ups"), message: LS("incorrect_data"), action: nil, comletion: nil)
            }
        })

    }
    
    
    // MARK: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
