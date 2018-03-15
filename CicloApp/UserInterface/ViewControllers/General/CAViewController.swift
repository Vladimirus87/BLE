//
//  CAViewController.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 14.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class CAViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var isResized = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateLocalization()
        
        let tapKeyboard = UITapGestureRecognizer.init(target: self, action: #selector(closeKeyboard))
        tapKeyboard.cancelsTouchesInView = false
        tapKeyboard.delegate = self;
        self.view.addGestureRecognizer(tapKeyboard)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateColorScheme), name: Notification.Name(Config.notificationSettingsColor), object: nil)
        
        self.updateColorScheme()
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        closeKeyboard()
    }
    
    // Mark: - Resizing
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if (!self.isResized) {
            self.isResized = true
            
            resizeSubviews()
        }
        
    }
    
    func resizeSubviews() {
        
        
    }
    
    func updateLocalization() {
        
    }
    
    @objc func closeKeyboard() {
        
    }
    
    // Mark: - Notifications
    
    @objc func updateColorScheme() {
        
    }
    
    @objc func updateTextSize() {
        
    }
    
    // Mark: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is UIControl)
    }
    
    // Mark: -

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
