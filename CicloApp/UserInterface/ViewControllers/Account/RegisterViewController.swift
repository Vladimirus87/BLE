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

