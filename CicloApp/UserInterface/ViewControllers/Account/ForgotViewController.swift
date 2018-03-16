//
//  ForgotViewController.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 16.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class ForgotViewController: AccountViewController {
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var imageHeader: UIImageView!
    
    @IBOutlet weak var buttonSendLink: CAButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initWithData("ForgotPassword")
    }

    override func resizeSubviews() {
        
        let height = self.imageHeader.frame.origin.y + (self.view.frame.size.width * self.imageHeader.image!.size.height / self.imageHeader.image!.size.width)
        
        self.viewHeader.frame = CGRect.init(x: self.viewHeader.frame.origin.x, y: self.viewHeader.frame.origin.y,
                                            width: self.viewHeader.frame.size.width, height: height)
        print("height \(height)")
        
        self.tableViewData.tableHeaderView = nil;
        self.tableViewData.tableHeaderView = self.viewHeader;
        
        self.tableViewData.reloadData();
        
    }
    
    override func dataValuesChecked(_ result : Bool!) {
        self.buttonSendLink.isAvailable = result
    }
    
    
    // MARK: - Kyboard
    
    override func updateKeyboardHeight(_ keyboardHeight : CGFloat) {
        self.constraintTableViewDataBottom.constant = -keyboardHeight
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Navigation
 
    @IBAction func unwindFromCompleteDialog(segue:UIStoryboardSegue) {
        
        dismiss(animated: false, completion: {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
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
