//
//  WithoutAccountViewController.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 15.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class WithoutAccountViewController: CAViewController {

    @IBOutlet weak var buttonDontAsk: UIButton!
    var dontAskAgain = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    // MARK: - Actions
    
    @IBAction func buttonDontAskPressed(_ button: UIButton) {
        
        self.dontAskAgain = !self.dontAskAgain
        
        if (self.dontAskAgain) {
            button.setImage(#imageLiteral(resourceName: "checkbox"), for: .normal)
        } else {
            button.setImage(#imageLiteral(resourceName: "checkbox_clear"), for: .normal)
        }
        
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
