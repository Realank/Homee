//
//  SwtichData.swift
//  Homee
//
//  Created by Realank-Mac on 15/4/5.
//  Copyright (c) 2015年 Realank-Mac. All rights reserved.
//

import UIKit

protocol SwitchDataHasUpdateDelegate{
    func switchDataHasUpdate()
}

class SwitchItem{
    var name : String
    var waiting : Bool
    var type : Int
    var value : Int
    convenience init(){
        self.init(named: "未知",withWait: true, type: 2, andValue: 0)

    }
    init(named:String, withWait wait:Bool, type :Int, andValue value:Int){
        self.name = named
        self.waiting = wait
        self.type = type
        self.value = value
    }
    
}

class SwitchData : receiveSocketMsgDelegate {
    
    var switchDataHasUpdateDelegater : SwitchDataHasUpdateDelegate?
    let sectionsForTable = 1
    var switches = [SwitchItem]()
    let sockcom = SocketComm()
    
    init(){
        sockcom.receiverDelegater = self
    }
    
    
    func numberOfRowsInSection() -> Int{
        println("request numberOfRowsInSection:\(switches.count)")
        return switches.count
        
    }
    
    func reloadData(){
        switches.removeAll(keepCapacity: true)
        for _ in 1...5{
            sockcom.communicate(dataToSend: "LITE:CHEK:LVRM:0000")
        }

    }
    
    func setSpecificData(switchName: String, withValue value: Int){
        for swch in switches{
            if(swch.name == switchName)
            {
                //sockcom.communicate()
                swch.waiting = true
                swch.value = value
            }
        }
        switchDataHasUpdateDelegater?.switchDataHasUpdate()
    }
    
    func receivedBufferFromSocket(count: Int, data: String) {
        dispatch_async(dispatch_get_main_queue()){
            var strArray = data.split(":")
            println("Switchdata received Socket Answer is: \(strArray) bytes: \(count)")
            var swch = SwitchItem(named: "客厅灯 \(random()%10)", withWait: false, type:(random()%2+2), andValue: 1)
            self.switches.append(swch)
            self.switches.sort({ (before , after) -> Bool in
                // add some sort
                return true
            })
            self.switchDataHasUpdateDelegater?.switchDataHasUpdate()
        }
    }
    
    
}
