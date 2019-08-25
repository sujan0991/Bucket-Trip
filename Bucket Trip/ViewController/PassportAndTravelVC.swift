//
//  PassportAndTravelVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 30/6/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit

class PassportAndTravelVC: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    
    fileprivate let itemsPerRow: CGFloat = 2
    
    var heightPerItem = 150
    
    var histories:[TripModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(UINib.init(nibName: "PassportCollectionCell", bundle: nil), forCellWithReuseIdentifier: "PassportCollectionCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        self.collectionView?.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIManager.manager.getMyPassports { (trps) in
            self.histories = trps
            self.collectionView.reloadData()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PassportDetailsVC"{
            let dest:PassportDetailsVC = segue.destination as! PassportDetailsVC
            dest.selectedTrip = sender as? TripModel
        }
    }
}


extension PassportAndTravelVC:UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return histories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell:PassportCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PassportCollectionCell", for: indexPath) as! PassportCollectionCell
         let info: TripModel = histories[indexPath.item]
        cell.setInfo(info)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
         let info: TripModel = histories[indexPath.item]
        
        self.performSegue(withIdentifier: "PassportDetailsVC", sender: info)
    }
    
}
extension PassportAndTravelVC : UICollectionViewDelegateFlowLayout {
    
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


