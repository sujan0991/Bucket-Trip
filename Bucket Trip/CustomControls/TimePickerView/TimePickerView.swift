//
//  Pickerview.swift
//  Flangoo
//
//  Created by Dulal Hossain on 3/16/17.
//  Copyright © 2017 Raju. All rights reserved.
//

import UIKit

protocol TimePickerViewDelegate {
    func didPressCancel()

    func didSelect(_ date:Date)
}

class TimePickerView: UIView {
    
    @IBOutlet weak var pickerView: UIDatePicker! = UIDatePicker()
    
    var delegate: TimePickerViewDelegate?

    
    var selectedData: Date?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.setDate(Date(), animated: true)
      //  pickerView.minimumDate = Date()
    }
    
    @IBAction func pickerCancelAction(_ sender: AnyObject) {
        delegate?.didPressCancel()
    }
    
    @IBAction func pickerDoneAction(_ sender: AnyObject) {
        selectedData = pickerView.date
        guard let d = selectedData else{
           // delegate?.didPressCancel()
            return
        }
        delegate?.didSelect(d)
    }
}
