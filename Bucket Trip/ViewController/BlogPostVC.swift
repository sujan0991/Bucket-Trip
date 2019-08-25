//
//  BlogPostVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 30/6/18.
//  Copyright © 2018 DL. All rights reserved.
//


import UIKit


enum BlogType:String {
    case mine = "myblog"
    case all = "all"
}
class BlogPostVC: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    
    fileprivate let itemsPerRow: CGFloat = 2
    
    var heightPerItem = 150
    
    var blogs:[BlogModel] = []
    var blogType:BlogType = .all{
        didSet{
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // blogType = .all
        collectionView?.register(UINib.init(nibName: "HistoryCollectionCell", bundle: nil), forCellWithReuseIdentifier: "HistoryCollectionCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        self.collectionView?.reloadData()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APIManager.manager.getBlogPosts(type: blogType) { (blogs) in
            self.blogs = blogs
            self.collectionView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func creatBlogAction(_ sender:UIButton){
        self.performSegue(withIdentifier: "CreateBlogVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BlogDetailsVC"{
            let evc = segue.destination as! BlogDetailsVC
            evc.selectedBlog = sender as? BlogModel
        }
    }
}


extension BlogPostVC:UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return blogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell:HistoryCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCollectionCell", for: indexPath) as! HistoryCollectionCell
         let info: BlogModel = blogs[indexPath.item]
        cell.fill(info)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let info: BlogModel = blogs[indexPath.item]

         self.performSegue(withIdentifier: "BlogDetailsVC", sender: info)
    }
    
}
extension BlogPostVC : UICollectionViewDelegateFlowLayout {
    
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

