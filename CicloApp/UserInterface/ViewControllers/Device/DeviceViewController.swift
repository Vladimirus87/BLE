//
//  DeviceViewController.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 14.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class DeviceViewController: CAViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewData: UITableView!
    
    let cellIdentifier = "DeviceInfoTableViewCell"
    var data = [[String : String]]()
    
    var bleConnector: BLEPeripheral?
    
    @IBOutlet weak var labelFirmware: UILabel!
    @IBOutlet weak var labelFirmwareValue: UILabel!
    
    @IBOutlet weak var buttonUpdate: CAButton!
    
    @IBOutlet weak var labelMemory: UILabel!
    @IBOutlet weak var labelMemoryValue: UILabel!
    
    @IBOutlet weak var buttonSync: CAButton!
    @IBOutlet weak var buttonDisconnect: CAButton!
    
    @IBOutlet weak var labelPreferences: UILabel!
    
    var idFirmware: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.labelFirmwareValue.text = "v\(AccountApi.shared.version)"
        buttonUpdate.isHidden = true
        
        let pathData = Bundle.main.path(forResource: "DeviceInfo", ofType: "plist")
        self.data = NSArray(contentsOfFile: pathData!) as! [[String : String]]
    
        self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)

        AccountApi.shared.findActualVersion { (success, id) in
            if success {
                self.idFirmware = id
                self.buttonUpdate.isHidden = false
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
    
    // Mark: - Actions
    
    @IBAction func buttonDisconnectPressed(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    @IBAction func syncBtnPressed(_ sender: CAButton) {
//        var ind = 1
        if let bleConnector = bleConnector {
            
            bleConnector.sendFirmWare()
//            let testEvent = BLEDataModel(word: "BlaBlaBla \(ind)")
//            ind += 1
////            let error = bleConnector.sendNavigationDataObject(testEvent)
//
//            let alert = UIAlertController(title: nil, message: "\("error")", preferredStyle: .alert)
//            self.present(alert, animated: true, completion: nil)
//
//            let when = DispatchTime.now() + 1
//            DispatchQueue.main.asyncAfter(deadline: when){
//                alert.dismiss(animated: true, completion: nil)
//            }
        }
    }
    
    @IBAction func updatePressed(_ sender: CAButton) {

        guard let id = idFirmware else { return }
            AccountApi.shared.getFirmware(id: id, view: self.view) { (success) in
                if success {
                    self.labelFirmwareValue.text = "v\(AccountApi.shared.version)"
                    self.buttonUpdate.isHidden = true
                    self.idFirmware = nil
                    self.alert(with: "Success", message: "The latest version was downloaded", action: nil, comletion: nil)
                } else {
                    self.alert(with: "Download error!", message: nil, action: nil, comletion: nil)
                }
            }
        
    }
    
    
    // Mark: - Notifications
    
    override func updateColorScheme() {
        super.updateColorScheme()
        
        self.tableViewData.backgroundColor = Config.shared.backgroundColor()
        
        self.labelFirmware.textColor = Config.shared.textColor()
        self.labelFirmwareValue.textColor = Config.shared.subTextColor()
        
        self.buttonUpdate.tintColor = Config.shared.baseColor()
        
        self.labelMemory.textColor = Config.shared.textColor()
        self.labelMemoryValue.textColor = Config.shared.subTextColor()
        
        self.buttonSync.backgroundColor = Config.shared.baseColor()
        self.buttonDisconnect.tintColor = Config.shared.baseColor()
        
        self.labelPreferences.textColor = Config.shared.subTextColor()
        
    }
    
    // MARK: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
