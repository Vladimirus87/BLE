//
//  CAViewController.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 14.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class CAViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var lableTitle: UILabel!
    
    var isResized = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateLocalization()
        
        let tapKeyboard = UITapGestureRecognizer.init(target: self, action: #selector(closeKeyboard))
        tapKeyboard.cancelsTouchesInView = false
        tapKeyboard.delegate = self;
        self.view.addGestureRecognizer(tapKeyboard)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateColorScheme), name: Notification.Name(Config.notificationSettingsColorMode), object: nil)
        
        self.updateColorScheme()
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CAViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CAViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        closeKeyboard()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        let obj = (notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        self.updateKeyboardHeight(obj.cgRectValue.size.height)
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        self.updateKeyboardHeight(0.0)
        
    }

    func updateKeyboardHeight(_ keyboardHeight : CGFloat) {
        
    }

    // Mark: - Notifications
    
    @objc func updateColorScheme() {
        
        if let labelTitle = self.lableTitle {
            labelTitle.textColor = Config.shared.titleColor()
        }
        
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
