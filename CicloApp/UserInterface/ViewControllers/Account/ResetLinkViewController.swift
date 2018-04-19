//
//  ResetLinkViewController.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 16.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class ResetLinkViewController: CAViewController {

    var isManagedAccount = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(_ sender: CAButton) {
        if isManagedAccount {
            print("isManagedAccount")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func okPressed(_ sender: CAButton) {
        performSegue(withIdentifier: "unwindFromCompleteDialog", sender: self)
    }

}
