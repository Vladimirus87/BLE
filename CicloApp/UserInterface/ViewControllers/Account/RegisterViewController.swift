//
//  RegisterViewController.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 15.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class RegisterViewController: CAViewController, UITableViewDelegate, UITableViewDataSource, EditAccountTableViewCellDelegate {
    
    @IBOutlet weak var tableViewData: UITableView!
    @IBOutlet weak var buttonRegister: CAButton!
    @IBOutlet weak var buttonAgree: UIButton!
    
    let cellIdentifier = "EditAccountTableViewCell"
    var data = [NSMutableDictionary]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        let pathData = Bundle.main.path(forResource: "Register", ofType: "plist")
        let array = NSArray(contentsOfFile: pathData!) as! [[String : String]]
        
        for item in array {
            
            let dict: NSMutableDictionary = NSMutableDictionary(dictionary: item)
            
            self.data.append(dict)
            
        }
        
        self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
    }
    
    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.data.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EditAccountTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        
        cell.delegate = self
        
        let item = self.data[indexPath.row]
        cell.updateWithData(data : item as! [String : String])
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - EditAccountTableViewCellDelegate
    
    func editAccountValueWasChanged(_ field: String, _ value : String) {
        
        for item in self.data {
            if let itemField = item["field"] as? String {
                if itemField == field {
                    item["value"] = value
                }
            }
        }
        
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
    
    // MARK: - Keyboard
    
    override func closeKeyboard() {
        
        let cells: [EditAccountTableViewCell] = self.tableViewData.visibleCells as! [EditAccountTableViewCell]
        for cell in cells {
            cell.closeKeyboard()
        }
        
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

