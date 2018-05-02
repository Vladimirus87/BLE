//
//  ConnectViewController.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 14.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit
import CoreBluetooth

class ConnectViewController: CAViewController, UITableViewDelegate, UITableViewDataSource, ConnectTableViewCellDelegate {

    @IBOutlet weak var viewConnect: UIView!
    @IBOutlet weak var viewProgress: CAProgress!
    @IBOutlet weak var labelProgress: UILabel!
    @IBOutlet weak var tableViewData: UITableView!
    @IBOutlet weak var reloadBtn: CAButton!
    
    let cellIdentifier = "ConnectTableViewCell"
    var timer: Timer?
    var progress: Double = 0.0
    var manager: BLEPeripheral?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        manager = (UIApplication.shared.delegate as! AppDelegate).manager
        manager?.delegate = self
        
        reloadBtn.isHidden = false
        self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        if manager != nil, (manager?.subscribedCentral.isEmpty)! {
            startConnectTimer()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleBLENotification(notification:)), name: BLEPeripheral.MessageNotification, object: nil)
    }
    
    
    @objc func handleBLENotification(notification: Notification) {
        if let message = notification.object as? String {
            print(message)
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    
    // MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager?.subscribedCentral.count ?? 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConnectTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        
        cell.delegate = self
        cell.updateWithData(value: nil, (indexPath.row == 2))
        
        return cell
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    
    func showErrorAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
   
    
    // MARK: -ConnectTableViewCellDelegate:
    
    func connectCellPairPressed(_ value: Any?) {
        
        self.performSegue(withIdentifier: "ShowDevice", sender: value)
    }
    
    
    func startConnectTimer() {
        
        reloadBtn.isHidden = true
        if (self.timer == nil) {
//            connector?.subscribedCentrals = []
//            tableViewData.reloadData()
            
//            if let errorType = connector?.startAdvertisingNavigationService(true) {
//                if errorType != .success {
//                    self.handleBluetoothErrorType(errorType)
//                }
//            }
            
            self.progress = 0.0
            self.viewProgress.updateWithProgress(self.progress, width: 2.0, color: Config.shared.baseColor())
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.animateTimer), userInfo: nil, repeats: true)
        }
    }
    
    
    @IBAction func reloadBtnPressed(_ sender: CAButton) {
        startConnectTimer()
        manager?.startAdvertising()
    }
    
    
    @objc func animateTimer() {
        
        self.progress += 1
        self.viewProgress.updateWithProgress(self.progress / 30.0, width: 2.0, color: Config.shared.baseColor())
        self.labelProgress.text = String(Int(self.progress))
        
        if (self.progress >= 30.0) {
            stopConnectTimer()
        }
        
    }
    
    func stopConnectTimer() {
        
        if (self.timer != nil) {
            
            self.timer?.invalidate()
            self.timer = nil
            self.tableViewData.isUserInteractionEnabled = true
            //self.viewConnect.isHidden = true
            
            manager?.stopAdvertising()
            reloadBtn.isHidden = false
        }
        
    }
    

    // Mark: - Notifications
    
    override func updateLocalization() {
        
        self.lableTitle.text = LS("pair_with_device")
    }
    
    override func updateColorScheme() {
        super.updateColorScheme()
        
        self.view.backgroundColor = Config.shared.backgroundColor()
        
        self.viewConnect.layer.borderWidth = 2.0
        self.viewConnect.layer.borderColor = Config.shared.actionBgColor().cgColor
        
        self.labelProgress.textColor = Config.shared.baseColor()
    }
    

    // MARK: -
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDevice", let destVC = segue.destination as? DeviceViewController {
            destVC.bleConnector = manager
        }
    }
}


extension ConnectViewController: BLEPeripheralDelegate {
    
    func didChangeSubscribedCentral() {
        tableViewData.reloadData()
    }
}
