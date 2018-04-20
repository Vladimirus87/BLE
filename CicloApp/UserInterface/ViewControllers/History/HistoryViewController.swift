//
//  HistoryViewController.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 14.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit


class HistoryViewController: CAViewController, UITableViewDelegate, UITableViewDataSource, HistoryTableViewCellDelegate, UIDocumentInteractionControllerDelegate {

    @IBOutlet weak var buttonSelect: UIButton!
    @IBOutlet weak var buttonSearch: UIButton!

    
    let searchController = UISearchController(searchResultsController: nil)
    
    var tracksOnDevice = [CATrack]()
    var tracksLocal = [CATrack]()
    
    var filteredTracksOnDevice = [CATrack]()
    var filteredTracksLocal = [CATrack]()
    
    var isSelectManyPressed = false
    
    var documentController: UIDocumentInteractionController!
    
    @IBOutlet weak var tableViewData: UITableView!
    
    let headerIdentifier = "HistoryTableHeaderView"
    let cellIdentifier = "HistoryTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableViewData.tableHeaderView = searchController.searchBar
        
        tableViewData.tableHeaderView = nil
        searchController.isActive = false
        
        
        
        
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return (section == 0) ? self.filteredTracksOnDevice.count : self.filteredTracksLocal.count
        } else {
            return (section == 0) ? self.tracksOnDevice.count : self.tracksLocal.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var array : [CATrack]
        
        if isFiltering() {
            array = (indexPath.section == 0) ? self.filteredTracksOnDevice : self.filteredTracksLocal
        } else {
            array = (indexPath.section == 0) ? self.tracksOnDevice : self.tracksLocal
        }
       
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HistoryTableViewCell
        
        let track = array[indexPath.row]
        cell.updateWithTrack(track: track, indexPath.row == (array.count - 1))
        cell.delegate = self
        cell.leftConstantOfLbl.constant = isSelectManyPressed ? 50 : 25
        cell.checkbox.isHidden = isSelectManyPressed ? false : true
        cell.checkbox.image = UIImage(named: "icon_checkbox_off")
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableViewData.cellForRow(at: indexPath) as! HistoryTableViewCell
        if isSelectManyPressed {
            cell.checkboxPressed()
        }
    }
    

    
    // Mark: - HistoryTableViewCellDelegate
    
    func historyActionSelected(_ track :CATrack) {
        let pngRepresentation = UIImageJPEGRepresentation(UIImage(named: "background_image")!, 0.9)
        
//        AccountApi.shared.upload(pngRepresentation!, filename: "background_image", view: self.view) { (success) in
//            if success {
//                track.trackState = .complete
//                self.tableViewData.reloadData()
//                self.alert(with: "Uploaded", message: nil, action: nil, comletion: nil)
//            } else {
//                track.trackState = .onDevice
//                self.tableViewData.reloadData()
//                self.alert(with: "Error", message: nil, action: nil, comletion: nil)
//            }
//        }
        
        
        if (track.trackState == .onDevice) {
            track.trackState = .loading
            self.tableViewData.reloadData()
        } else if (track.trackState == .loading) {
            track.trackState = .onDevice
            self.tableViewData.reloadData()
        
        } else if (track.trackState == .local) {
 
            let activityViewController = UIActivityViewController(activityItems: [pngRepresentation!], applicationActivities: nil)
            
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            //Проверить на ipad
            if UIDevice.current.userInterfaceIdiom == .pad {
                if activityViewController.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                    activityViewController.popoverPresentationController?.sourceView = self.view
                }
            }
            
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    
    func historyDeleteSelected(_ track :CATrack) {
        if track.trackState == .local {
            
            if isFiltering() {
                guard let ind = filteredTracksLocal.index(of: track) else {return}
                filteredTracksLocal.remove(at: ind)
                let indexP = IndexPath(row: ind, section: 1)
                tableViewData.deleteRows(at: [indexP], with: .fade)
                guard let ind2 = tracksLocal.index(of: track) else {return}
                tracksLocal.remove(at: ind2)
                
            } else {
                guard let ind = tracksLocal.index(of: track) else {return}
                tracksLocal.remove(at: ind)
                let indexP = IndexPath(row: ind, section: 1)
                tableViewData.deleteRows(at: [indexP], with: .fade)
            }
            
        } else {
            
            if isFiltering() {
                guard let ind = filteredTracksOnDevice.index(of: track) else {return}
                filteredTracksOnDevice.remove(at: ind)
                let indexP = IndexPath(row: ind, section: 0)
                tableViewData.deleteRows(at: [indexP], with: .fade)
                guard let ind2 = tracksOnDevice.index(of: track) else {return}
                tracksOnDevice.remove(at: ind2)
            } else {
                guard let ind = tracksOnDevice.index(of: track) else {return}
                tracksOnDevice.remove(at: ind)
                let indexP = IndexPath(row: ind, section: 0)
                tableViewData.deleteRows(at: [indexP], with: .fade)
            }
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
    
    
    @IBAction func selectManyPressed(_ sender: UIButton) {

        isSelectManyPressed = !isSelectManyPressed
        
        if isSelectManyPressed == false {
            buttonSearch.setImage(UIImage(named: "icon_search"), for: .normal)
            
            for track in tracksLocal {
                if track.isChecked == true {
                    track.isChecked = false
                }
            }
            for track in tracksOnDevice {
                if track.isChecked == true {
                    track.isChecked = false
                }
            }
            
        } else {
            
            buttonSearch.setImage(UIImage(named: "icon_trashcan"), for: .normal)
        }
        
        tableViewData.reloadData()
    }
    
    
    @IBAction func serchPressed(_ sender: UIButton) {
        
        
        
        if isSelectManyPressed {
            
            for track in tracksLocal {
                if track.isChecked == true {
                    if let ind = tracksLocal.index(of: track) {
                        tracksLocal.remove(at: ind)
                    }
                    
                }
            }
            for track in tracksOnDevice {
                if track.isChecked == true {
                    track.isChecked = false
                    if let ind = tracksOnDevice.index(of: track) {
                        tracksOnDevice.remove(at: ind)
                    }
                }
            }
        
            self.tableViewData.reloadData()
            
        } else {
            
            UIView.animate(withDuration: 0.5, animations: {
                self.tableViewData.tableHeaderView = self.searchController.searchBar
                self.searchController.isActive = true
                self.searchController.searchBar.delegate = self
            }, completion: { (value: Bool) in
                self.buttonSelect.isHidden = true
            //show keyboard
            })
        }
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

// MARK: - Search

extension HistoryViewController : UISearchBarDelegate {
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.2, animations: {
            self.tableViewData.tableHeaderView = nil
            self.searchController.isActive = false
        }, completion: { (value: Bool) in
            //hide keyboard
            self.buttonSelect.isHidden = false
        })
    }
}

extension HistoryViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
    // MARK: - Search
    
    func filterContentForSearchText(_ searchText: String) {
        filteredTracksOnDevice = tracksOnDevice.filter({( name : CATrack) -> Bool in
            
            return name.date!.string(with: "dd-MM-yyyy").lowercased().contains(searchText.lowercased())
        })
        
        filteredTracksLocal = tracksLocal.filter({( name : CATrack) -> Bool in
            
            return name.date!.string(with: "dd-MM-yyyy").lowercased().contains(searchText.lowercased())
        })
        
        tableViewData.reloadData()
    }
    
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}

