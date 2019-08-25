//
//  HomeVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 25/5/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit
import SnapKit
import ViewUtils

enum SegmentType {
    case history
    case travelfeature
}

class HomeVC: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var segmentView: UIView!

    fileprivate let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    fileprivate let itemsPerRow: CGFloat = 2
    
    var heightPerItem = 150
    var histories:[BlogHistoryModel] = []

    @IBOutlet var menuButton:GeneralButton!
    @IBOutlet var rightButton:GeneralButton!
    @IBOutlet var titleLabel:GeneralLabel!
    @IBOutlet var historyTitleButton:UIButton!
    @IBOutlet var acceptedTitleButton:UIButton!

    
    lazy var featureMenuView: HomeMenuView = {
        let mod:HomeMenuView = HomeMenuView.instance(withNibName: "HomeMenuView", bundle: Bundle.main, owner: self) as! HomeMenuView
        return mod
    }()
    
    var segType:SegmentType = .history{
        didSet{
            historyTitleButton.setTitleColor(segType == .history ? UIColor.white:UIColor.init(red: 90/255, green: 90/255, blue: 90/255, alpha: 1), for: .normal)
            acceptedTitleButton.setTitleColor(segType == .travelfeature ? UIColor.white:UIColor.init(red: 90/255, green: 90/255, blue: 90/255, alpha: 1), for: .normal)
            let selectedImage = UIImage.init(named: "add_button")
            let normalImage = UIImage.init(named: "added")
            
            historyTitleButton.setBackgroundImage(segType == .history ? selectedImage:normalImage, for: .normal)

            acceptedTitleButton.setBackgroundImage(segType == .travelfeature ? selectedImage:normalImage, for: .normal)
            collectionView.isHidden = segType == .travelfeature
            featureMenuView.isHidden = segType == .history
            collectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(UINib.init(nibName: "TaskCollectionCell", bundle: nil), forCellWithReuseIdentifier: "TaskCollectionCell")
        collectionView?.register(UINib.init(nibName: "HistoryCollectionCell", bundle: nil), forCellWithReuseIdentifier: "HistoryCollectionCell")

        collectionView?.delegate = self
        collectionView?.dataSource = self
        self.collectionView?.reloadData()

        self.view.addSubview(featureMenuView)
        featureMenuView.passportHandler = {
            self.performSegue(withIdentifier: "PassportAndTravelVC", sender: self)
        }
        featureMenuView.acceptedTasksHandler = {
            self.performSegue(withIdentifier: "AcceptedTasksVC", sender: self)

        }
        featureMenuView.pendingTasksHandler = {
            self.performSegue(withIdentifier: "PendingTasksVC", sender: self)
        }
        featureMenuView.tripLocationHandler = {
            self.performSegue(withIdentifier: "TripAndLocationsVC", sender: self)
        }
        featureMenuView.friendsHandler = {
            self.performSegue(withIdentifier: "FriendsVC", sender: self)
        }
        featureMenuView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
//            make.top.equalTo(segmentView.bottom).offset(0)
            make.top.equalToSuperview().offset((segmentView.frame.origin.y + segmentView.frame.height)-44)

        }
        segType = .history
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIManager.manager.getTravelHistories { (bhs) in
            self.histories = bhs
            self.collectionView.reloadData()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BlogDetailsVC"{
            let evc = segue.destination as! BlogDetailsVC
            evc.selectedBlogHistory = sender as? BlogHistoryModel
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuButtonAction(_ sender:GeneralButton){
        self.evo_drawerController?.toggleDrawerSide(.left, animated: true, completion: nil)
    }
    
    @IBAction func rightButtonAction(_ sender:GeneralButton){
        
    }
    
    
    @IBAction func historySelectAction(_ sender:UIButton){
        segType = .history
    }
    @IBAction func acceptedSelectAction(_ sender:UIButton){
        segType = .travelfeature
    }
}

extension HomeVC:UICollectionViewDataSource, UICollectionViewDelegate{
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
        if segType == .history{
            let info: BlogHistoryModel = histories[indexPath.item]
            self.performSegue(withIdentifier: "BlogDetailsVC", sender: info)
        }
    }
    
}
extension HomeVC : UICollectionViewDelegateFlowLayout {
    
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


