//
//  DeviceProfileViewController.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 19.03.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class DeviceProfileViewController: SettingsViewController {

    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonReset: UIButton!
    
    var profile : CAProfile?
    
    override func viewDidLoad() {
        
        self.dataName = "DeviceProfile";
        super.viewDidLoad()
        
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.data[indexPath.row]
        
        let cellIdentifier = "Settings\(item["type"]!)TableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        
        cell.updateWithData(data: item, object: self.profile)
        
        return cell
    }
    
    // MARK: - Actions
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    // Mark: - Notifications
    
    override func updateLocalization() {
        self.lableTitle.text = "\(LS("profile")) \(self.profile!.id!)"
        
        self.buttonReset.setTitle(LS("reset_to_default"), for: .normal)
    }
    
    override func updateColorScheme() {
        super.updateColorScheme()
        
        self.buttonBack.tintColor = Config.shared.titleColor()
        self.view.backgroundColor = Config.shared.backgroundColor()
        self.tableViewData.reloadData()
        
        self.buttonReset.backgroundColor = Config.shared.baseColor()
        
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
