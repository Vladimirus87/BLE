//
//  DeviceUserViewController.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 19.03.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class DeviceUserViewController: SettingsViewController {

    @IBOutlet weak var buttonBack: UIButton!
    
    override func viewDidLoad() {
        
        self.dataName = "DeviceUser";
        super.viewDidLoad()
        
    }
    
    // MARK: - Actions
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    // Mark: - Notifications
    
    override func updateLocalization() {
        self.lableTitle.text = LS("user")
    }
    
    override func updateColorScheme() {
        super.updateColorScheme()
        
        self.buttonBack.tintColor = Config.shared.titleColor()
        self.view.backgroundColor = Config.shared.backgroundColor()
        self.tableViewData.reloadData()
        
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
