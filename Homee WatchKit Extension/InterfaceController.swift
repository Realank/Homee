//
//  InterfaceController.swift
//  Homee WatchKit Extension
//
//  Created by Realank-Mac on 15/6/27.
//  Copyright (c) 2015年 Realank-Mac. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    
    @IBOutlet weak var lightNum: WKInterfaceLabel!
    
    
    @IBAction func refresh() {
        println("refresh called")
        WKInterfaceController.openParentApplication(["refresh":"check"], reply: {(replyInfo, error) -> Void in
            if let dic = replyInfo{
                if let value = dic["lightNum"]{
                    self.lightNum.setText("\(value)")
                }
            }
        })
        
    }
    
    

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        
        var value = 0
        
        println("will Activate called")
        // This method is called when watch view controller is about to be visible to user
//        if let userDefault:NSUserDefaults = NSUserDefaults(suiteName: "group.AWdataShare") {
//            value = userDefault.integerForKey("lightNum")
//            //userDefault.setInteger(SwitchData.switches.count, forKey: "lightNum")
//        }
//        if value > 0 {
//            lightNum.setText("\(value)")
//        }else{
//            lightNum.setText("N/A")
//        }
        
        WKInterfaceController.openParentApplication(["lightNum":"check"], reply: {(replyInfo, error) -> Void in
            if let dic = replyInfo{
                if let value = dic["lightNum"]{
                    self.lightNum.setText("\(value)")
                }
            }
            })
        

        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}






