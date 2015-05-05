//
//  SwitchTableViewCell.swift
//  Homee
//
//  Created by Realank-Mac on 15/4/5.
//  Copyright (c) 2015年 Realank-Mac. All rights reserved.
//

import UIKit

protocol SwitchChangedDelegate{
    func switchChangedByUser(switchName: String, withValue: Int)
}

class SwitchTableViewCell: UITableViewCell {

    var switchChangedDelegater : SwitchChangedDelegate?

    @IBOutlet weak var switchName: UILabel!
    @IBOutlet weak var switchWaitIndicator: UIActivityIndicatorView!
    @IBOutlet weak var switchSegment: UISegmentedControl!
    @IBAction func switchChanged(sender: UISegmentedControl) {
        switchChangedDelegater?.switchChangedByUser(switchName.text!, withValue: switchSegment.selectedSegmentIndex)
    }
    
    func setStatus(name:String, wait:Bool, statNum:Int){
        switchName.text = name;
        if wait == true {
            switchWaitIndicator.startAnimating()
            switchSegment.enabled = false
        }else{
            switchWaitIndicator.stopAnimating()
            switchSegment.enabled = true
            switchSegment.selectedSegmentIndex = statNum
        }

    }
    

}
