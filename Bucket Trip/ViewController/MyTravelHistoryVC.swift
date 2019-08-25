//
//  MyTravelHistoryVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 28/5/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit

class MyTravelHistoryVC: UIViewController {
    @IBOutlet var collectionView: UICollectionView!

    fileprivate let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    
    fileprivate let itemsPerRow: CGFloat = 2
    
    var heightPerItem = 150
    
    var histories:[BlogHistoryModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(UINib.init(nibName: "HistoryCollectionCell", bundle: nil), forCellWithReuseIdentifier: "HistoryCollectionCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        self.collectionView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIManager.manager.getTravelMyHistories { (bhs) in
            self.histories = bhs
            self.collectionView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension MyTravelHistoryVC:UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return histories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell:HistoryCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCollectionCell", for: indexPath) as! HistoryCollectionCell
        let info: BlogHistoryModel = histories[indexPath.item]
        cell.fill(info)
        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
       // let info: CityModel = cities[indexPath.item]
        
       // self.performSegue(withIdentifier: "UserListVC", sender: info)
    }
  
}
extension MyTravelHistoryVC : UICollectionViewDelegateFlowLayout {
    
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
