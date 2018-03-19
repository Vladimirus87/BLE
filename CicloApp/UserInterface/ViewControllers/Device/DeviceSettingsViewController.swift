//
//  DeviceSettingsViewController.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 19.03.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class DeviceSettingsViewController: CAViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var buttonBack: UIButton!
    
    @IBOutlet weak var tableViewData: UITableView!
    
    let cellIdentifier = "DeviceInfoTableViewCell"
    var data = [[String : String]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let pathData = Bundle.main.path(forResource: "DeviceSettings", ofType: "plist")
        self.data = NSArray(contentsOfFile: pathData!) as! [[String : String]]
        
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
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DeviceInfoTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        
        let item = self.data[indexPath.row]
        cell.updateWithData(data : item, (indexPath.row == (self.data.count - 1)))
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.data[indexPath.row]
        if let controllerName = item["controller"] {
            if controllerName.count > 0 {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: controllerName)
                self.navigationController?.pushViewController(controller!, animated: true)
            }
        }
        
    }
    
    // MARK: - Actions
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    // Mark: - Notifications
    
    override func updateLocalization() {
        self.lableTitle.text = LS("device_settings")
    }
    
    override func updateColorScheme() {
        super.updateColorScheme()
        
        self.buttonBack.tintColor = Config.shared.titleColor()
        self.view.backgroundColor = Config.shared.backgroundColor()
        
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
