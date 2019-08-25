//
//  ControlContainerView.swift
//
//  Created by Dulal Hossain on 2/11/17.
//  Copyright © 2017 deveyes. All rights reserved.
//

import UIKit

class ModelData {
    var model_id:Int?
    var name:String
    var logoImageName:String
    var showIcon:Bool = false
    var code:String?

    var balanceCode:String?
    var callMeCode:String?
    var collectCode:String?
    var serviceCenterCode:String?

    init(name:String, logo:String) {
        self.name = name
        self.logoImageName = logo
    }
}
protocol ModelPopupViewDelegate:AnyObject {
        func didSelectModel(_ model:CountryModel)
    }

    class ModelPopupView: UIView{
        
        @IBOutlet weak var tableView: UITableView!
        weak var delegate:ModelPopupViewDelegate?
        weak var parent:UIViewController?
        var models:[CountryModel] = []
        
        override func awakeFromNib() {
            self.tableView.register(UINib(nibName: "ModelTableCell", bundle: Bundle.main), forCellReuseIdentifier: "ModelTableCell")
            tableView.delegate = self
            tableView.dataSource = self
        }
        var popupTitle:String? = nil
  }

extension ModelPopupView:UITableViewDelegate,UITableViewDataSource{
  
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"ModelTableCell") as! ModelTableCell
        
        cell.fillModelInfo(models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let model = models[indexPath.row]
        delegate?.didSelectModel(model)
        self.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard popupTitle != nil else { return 0 }
        return 40    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let tl = popupTitle else { return "" }
        return tl
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: 40))
        let titleLabel = UILabel.init(frame: view.bounds)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.text = popupTitle
        titleLabel.textColor = UIColor.black
        view.addSubview(titleLabel)
        return view
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        
        layer.masksToBounds = true
        layer.shadowColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0).cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.3
    }
}
