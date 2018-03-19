//
//  ConnectViewController.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 14.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class ConnectViewController: CAViewController, UITableViewDelegate, UITableViewDataSource, ConnectTableViewCellDelegate {

    @IBOutlet weak var viewConnect: UIView!
    @IBOutlet weak var viewProgress: CAProgress!
    @IBOutlet weak var labelProgress: UILabel!
    
    @IBOutlet weak var tableViewData: UITableView!
    
    let cellIdentifier = "ConnectTableViewCell"
    
    var timer: Timer?
    var progress: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewConnect.isHidden = true
        self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)

        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.stopConnectTimer()
        
    }
    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
        
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
    
    // MARK: -ConnectTableViewCellDelegate:
    
    func connectCellPairPressed(_ value: Any?) {
        
        if (self.timer == nil) {
            self.tableViewData.isUserInteractionEnabled = false
            
            self.viewConnect.isHidden = false
            
            self.progress = 0.0
            self.viewProgress.updateWithProgress(self.progress, width: 2.0, color: Config.shared.baseColor())
            self.timer = Timer.scheduledTimer(timeInterval: 0.025, target: self, selector: #selector(animateTimer), userInfo: nil, repeats: true)
            
        }
        
        //self.performSegue(withIdentifier: "ShowDevice", sender: value)
    }

    
    @objc func animateTimer() {
        
        self.progress += 0.025
        self.viewProgress.updateWithProgress(self.progress / 1.0, width: 2.0, color: Config.shared.baseColor())
        self.labelProgress.text = String(Int(self.progress))
        
        if (self.progress >= 1.0) {
            stopConnectTimer()
            self.performSegue(withIdentifier: "ShowDevice", sender: nil)
        }
        
    }
    
    func stopConnectTimer() {
        
        if (self.timer != nil) {
            
            self.timer?.invalidate()
            self.timer = nil
            
            self.tableViewData.isUserInteractionEnabled = true
            self.viewConnect.isHidden = true
            
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
