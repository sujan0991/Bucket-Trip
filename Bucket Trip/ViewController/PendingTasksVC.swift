//
//  PendingTasksVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 2/6/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class PendingTasksVC: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)

    fileprivate let itemsPerRow: CGFloat = 2
    
    var heightPerItem = 150
    
    var pendingTrips:[TripModel] = []
    
    var isLoadingData:Bool = false{
        didSet{
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(UINib.init(nibName: "TaskCollectionCell", bundle: nil), forCellWithReuseIdentifier: "TaskCollectionCell")
        self.isLoadingData = true
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        self.collectionView?.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIManager.manager.getPendingTasks { (trips) in
            self.pendingTrips = trips
            self.isLoadingData = false

            self.collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PendingTaskDetailsVC"{
            let dest:PendingTaskDetailsVC = segue.destination as! PendingTaskDetailsVC
            let indp:IndexPath = sender as! IndexPath
            dest.selectedTrip = self.pendingTrips[indp.item]
        }
    }
}


extension PendingTasksVC:UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return pendingTrips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell:TaskCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCollectionCell", for: indexPath) as! TaskCollectionCell
         let info: TripModel = pendingTrips[indexPath.item]
        cell.fillPending(info)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
         self.performSegue(withIdentifier: "PendingTaskDetailsVC", sender: indexPath)
    }
    
}
extension PendingTasksVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = 2 * (itemsPerRow + 3)
        let availableWidth = (UIScreen.main.bounds.width-20)  - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        heightPerItem = Int(widthPerItem)
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}



extension PendingTasksVC:DZNEmptyDataSetSource{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.init(string: isLoadingData ? "":"No pending task.")
    }
    /*
     func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
     return  -100
     }
     */
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.init(red: 241, green: 241, blue: 241)
    }
}

extension PendingTasksVC:DZNEmptyDataSetDelegate{
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}

