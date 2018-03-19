//
//  HistoryViewController.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 14.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class HistoryViewController: CAViewController, UITableViewDelegate, UITableViewDataSource, HistoryTableViewCellDelegate {

    @IBOutlet weak var buttonSelect: UIButton!
    @IBOutlet weak var buttonSearch: UIButton!
    
    var tracksOnDevice = [CATrack]()
    var tracksLocal = [CATrack]()
    
    @IBOutlet weak var tableViewData: UITableView!
    
    let headerIdentifier = "HistoryTableHeaderView"
    let cellIdentifier = "HistoryTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tracksOnDevice.append(CATrack.init(trackState: .onDevice, date: Date().dateByAddingDays(-Int(arc4random_uniform(10)))))
        self.tracksOnDevice.append(CATrack.init(trackState: .onDevice, date: Date().dateByAddingDays(-Int(arc4random_uniform(10)))))
        self.tracksOnDevice.append(CATrack.init(trackState: .onDevice, date: Date().dateByAddingDays(-Int(arc4random_uniform(10)))))
        self.tracksOnDevice.append(CATrack.init(trackState: .onDevice, date: Date().dateByAddingDays(-Int(arc4random_uniform(10)))))
        
        self.tracksLocal.append(CATrack.init(trackState: .local, date: Date().dateByAddingDays(-Int(arc4random_uniform(10)))))
        self.tracksLocal.append(CATrack.init(trackState: .local, date: Date().dateByAddingDays(-Int(arc4random_uniform(10)))))
        self.tracksLocal.append(CATrack.init(trackState: .local, date: Date().dateByAddingDays(-Int(arc4random_uniform(10)))))
        self.tracksLocal.append(CATrack.init(trackState: .local, date: Date().dateByAddingDays(-Int(arc4random_uniform(10)))))
        

        self.tableViewData.register(UINib.init(nibName: headerIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: headerIdentifier)
        self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)

    }
    
    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as! HistoryTableHeaderView
        
        headerView.viewBg.backgroundColor = Config.shared.backgroundColor()
        headerView.labelTitle.textColor = Config.shared.subTextColor()
        headerView.buttonAction.backgroundColor = Config.shared.baseColor()
        
        headerView.labelTitle.text = (section == 0) ? LS("on_device") : LS("local")
        headerView.buttonAction.isHidden = (section > 0)
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? self.tracksOnDevice.count : self.tracksLocal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let array = (indexPath.section == 0) ? self.tracksOnDevice : self.tracksLocal
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HistoryTableViewCell
        
        let track = array[indexPath.row]
        cell.updateWithTrack(track: track, indexPath.row == (array.count - 1))
        cell.delegate = self
        
        return cell
        
    }
    
    // Mark: - HistoryTableViewCellDelegate
        
    func historyActionSelected(_ track :CATrack) {
        
        if (track.trackState == .onDevice) {
            track.trackState = .loading
            self.tableViewData.reloadData()
        } else if (track.trackState == .loading) {
            track.trackState = .onDevice
            self.tableViewData.reloadData()
        }
        
    }
    
    // Mark: - Notifications
    
    override func updateLocalization() {
        self.lableTitle.text = LS("history")
    }
    
    override func updateColorScheme() {
        super.updateColorScheme()
        
        self.view.backgroundColor = Config.shared.backgroundColor()
        self.buttonSelect.tintColor = Config.shared.textColor()
        self.buttonSearch.tintColor = Config.shared.textColor()
        
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
