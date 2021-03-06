//
//  MainTabsViewController.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 13.03.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class MainTabsViewController: CAViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var viewTabs: UIView!
    @IBOutlet weak var viewTabsDivider: UIView!
    @IBOutlet weak var collectionViewTabs: UICollectionView!
    
    @IBOutlet weak var viewContainer: UIView!
    
    var currentController : UIViewController!
    
    var dataArray : NSArray!
    var currentTab: Int = 0 {
        didSet {
            if (self.dataArray != nil) {
                let tabInfo = dataArray[currentTab]  as! [String : String]
                
                let controllerName = tabInfo["controller"]!
                let controller = self.storyboard?.instantiateViewController(withIdentifier: controllerName)
                
                add(asChildViewController: controller!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let path = Bundle.main.path(forResource: "MainTabs", ofType: "plist")
        dataArray = NSArray(contentsOfFile: path!)
        
        self.currentTab = 0
    }
    
    override func resizeSubviews() {
        super.resizeSubviews()
        
        self.collectionViewTabs.layoutIfNeeded()
        self.collectionViewTabs.reloadData()
        
    }
    
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

    // MARK: - Content Container
    
    private func add(asChildViewController viewController: UIViewController) {
        
        if (self.currentController != nil) {
            self.remove(asChildViewController: self.currentController)
        }
        
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        viewContainer.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = viewContainer.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
        
        self.currentController = viewController
        
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }

    
    // Mark: - Notifications
    
    override func updateColorScheme() {
        super.updateColorScheme()
        
        self.viewTabs.backgroundColor = Config.shared.tabsBgColor()
        self.viewTabsDivider.backgroundColor = Config.shared.tabsDividerColor()
        
        self.collectionViewTabs.reloadData()
        
    }
    
    // MARK: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
