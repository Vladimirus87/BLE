//
//  SettingsViewController.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 14.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class SettingsViewController: CAViewController, UITableViewDelegate, UITableViewDataSource, SettingsTableViewCellDelegate {
    
    @IBOutlet weak var tableViewData: UITableView!
    var data = [[String : String]]()

    var dataName = "Settings";
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initWithData(dataName)
    }
    
    func initWithData(_ fileName : String) {
        
        let pathData = Bundle.main.path(forResource: fileName, ofType: "plist")
        self.data = NSArray(contentsOfFile: pathData!) as! [[String : String]]
    
        var registered = [String]()
        
        for item in self.data {
            let cellIdentifier = "Settings\(item["type"]!)TableViewCell"
            
            if !registered.contains(cellIdentifier) {
                registered.append(cellIdentifier)
                self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
            }
        }
    
    }
    
    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.data.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.data[indexPath.row]
        
        let cellIdentifier = "Settings\(item["type"]!)TableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        
        cell.updateWithData(data: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.data[indexPath.row]
        
        if item["type"] != "TextField" {
            self.closeKeyboard()
        }
        
        if let controllerName = item["controller"] {
            if controllerName.count > 0 {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: controllerName)
                self.navigationController?.pushViewController(controller!, animated: true)
            }
        }
        
    }
    
    // MARK: - Keyboard
    
    override func closeKeyboard() {
        
        let cells: [SettingsTableViewCell] = self.tableViewData.visibleCells as! [SettingsTableViewCell]
        for cell in cells {
            cell.closeKeyboard()
        }
        
    }
    
    // Mark: - Notifications
    
    override func updateLocalization() {
        self.lableTitle.text = LS("settings")
    }
    
    override func updateColorScheme() {
        super.updateColorScheme()
        
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
