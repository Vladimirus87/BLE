//
//  StartViewController.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 15.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class StartViewController: CAViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    
    @IBAction func unwindWithoutAccount(segue:UIStoryboardSegue) {
        
        dismiss(animated: true, completion: {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "ShowMainTabsWithoutAccount", sender: self)
            }
        })
    }
    
    @IBAction func unwindFromDialog(segue:UIStoryboardSegue) {
        
        dismiss(animated: true, completion: {
            
        })
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
