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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let pathData = Bundle.main.path(forResource: "DeviceInfo", ofType: "plist")
        self.data = NSArray(contentsOfFile: pathData!) as! [[String : String]]
    
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
