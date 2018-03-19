//
//  DeviceProfilesViewController.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 19.03.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class DeviceProfilesViewController: CAViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var buttonBack: UIButton!
    
    @IBOutlet weak var tableViewData: UITableView!
    
    let cellIdentifier = "DeviceProfileTableViewCell"
    var profiles = [CAProfile]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.profiles.append(CAProfile.init(id: 1, profileName: "Laura's MTB", bikeWeight: "42", wheelDiameter: "27"))
        self.profiles.append(CAProfile.init(id: 2, profileName: "Alfred's citybike", bikeWeight: "37", wheelDiameter: "24"))
        self.profiles.append(CAProfile.init(id: 3, profileName: "Bernd's Race Bike", bikeWeight: "12", wheelDiameter: "25"))
        self.profiles.append(CAProfile.init(id: 4, profileName: "Michelle's Citybike", bikeWeight: "24", wheelDiameter: "27"))
        
        self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)

    }

    
    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.profiles.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DeviceProfileTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        
        let item = self.profiles[indexPath.row]
        cell.updateWithProfile(profile : item, (indexPath.row == (self.profiles.count - 1)))
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.profiles[indexPath.row]
        self.performSegue(withIdentifier: "ShowDeviceProfile", sender: item)
        
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
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowDeviceProfile" {
            let controller = segue.destination as! DeviceProfileViewController
            controller.profile = sender as? CAProfile
        }
        
    }
    
    
}
