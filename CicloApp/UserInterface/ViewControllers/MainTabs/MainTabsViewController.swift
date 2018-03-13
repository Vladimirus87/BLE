//
//  MainTabsViewController.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 13.03.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class MainTabsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionViewTabs: UICollectionView!
    
    var dataArray : NSArray!
    var currentTab: Int = 0 {
        didSet {
            if (self.dataArray != nil) {
                let tabInfo = dataArray[currentTab]
                
                print("Tab \(tabInfo)")
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let path = Bundle.main.path(forResource: "MainTabs", ofType: "plist")
        dataArray = NSArray(contentsOfFile: path!)
        
        self.currentTab = 0
    }
    /*
    override func resizeSubviews() {
        super.resizeSubviews()
        
        self.collectionViewTabs.layoutIfNeeded()
        self.collectionViewTabs.reloadData()
        
    }
    */
    
    // MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var count = dataArray.count
        if (count < 1) {
            count = 1
        }
        
        return CGSize.init(width: (collectionView.bounds.size.width / CGFloat(count)), height: collectionView.bounds.size.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "MainTabCollectionViewCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MainTabCollectionViewCell  else {
            fatalError("The dequeued cell is not an instance of OnBoardingCollectionViewCell.")
        }
        
        let tabInfo = dataArray[indexPath.row] as! [String : String]
        cell.updateWithTabInfo(tabInfo: tabInfo, isSelected: (indexPath.row == self.currentTab))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (self.currentTab != indexPath.row) {
            self.currentTab = indexPath.row
            self.collectionViewTabs.reloadData()
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
