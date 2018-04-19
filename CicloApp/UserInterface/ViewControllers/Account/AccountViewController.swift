//
//  AccountViewController.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 16.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class AccountViewController: CAViewController, UITableViewDelegate, UITableViewDataSource, EditAccountTableViewCellDelegate {
    
    @IBOutlet weak var tableViewData: UITableView!
    @IBOutlet weak var constraintTableViewDataBottom: NSLayoutConstraint!

    let cellIdentifier = "EditAccountTableViewCell"
    var data = [NSMutableDictionary]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func initWithData(_ fileName : String) {
        
        let pathData = Bundle.main.path(forResource: fileName, ofType: "plist")
        let array = NSArray(contentsOfFile: pathData!) as! [[String : String]]
        
        for item in array {
            let dict: NSMutableDictionary = NSMutableDictionary(dictionary: item)
            self.data.append(dict)
        }
        
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
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EditAccountTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        
            cell.delegate = self
        
        
        let item = self.data[indexPath.row]
        cell.updateWithData(data : item as! [String : String])
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - EditAccountTableViewCellDelegate
    
    func editAccountValueWasChanged(_ field: String, _ value : String) {
        
        var result = true
        
        for item in self.data {
            
            if let itemField = item["field"] as? String {
                if itemField == field {
                    item["value"] = value
                }
            }
            if let itemValue = item["value"] as? String {
                if itemValue.count == 0 {
                    result = false
                }
            }
        }
        
        self.dataValuesChecked(result)
        
    }
    
    func dataValuesChecked(_ result : Bool!) {
        
    }
    
    // MARK: - Keyboard
    
    override func closeKeyboard() {
        
        let cells: [EditAccountTableViewCell] = self.tableViewData.visibleCells as! [EditAccountTableViewCell]
        for cell in cells {
            cell.closeKeyboard()
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
