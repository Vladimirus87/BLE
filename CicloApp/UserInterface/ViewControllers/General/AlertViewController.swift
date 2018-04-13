//
//  AlertViewController.swift
//  CicloApp
//
//  Created by Владимир Моисеев on 13.04.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class AlertViewController: CAViewController {

    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var infoLBL: UILabel!
    
    var titleAlert: String?
    var infoLAlert: String?
    var action: Void?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLBL.text = titleAlert
        infoLBL.text = infoLAlert
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okPressed(_ sender: CAButton) {
        if let action = action {
            action
        } else {
            dismiss(animated: true, completion: nil)
        }
        
    }
    
}
