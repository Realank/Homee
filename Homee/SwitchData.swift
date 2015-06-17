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
    //还需要添加一个用于显示的名字，以及一个表示设备没有开启的disable状态
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
        sockcom.communicate(dataToSend: "LITE:CHEK:LVRM:0000")
        for i in 1...3{
            sockcom.communicate(dataToSend: "LITE:CHEK:BDRM:000\(i)")
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
            
            var swch : SwitchItem
            
            if strArray[0] == "LITE" && strArray[1] == "NHST" && strArray[2] == "LVRM"{
                
                swch = SwitchItem(named: "客厅灯 \(strArray[3].toInt() ?? 0)", withWait: false, type:(3), andValue: 1)

            } else if strArray[0] == "LITE" && strArray[1] == "NHST" && strArray[2] == "BDRM"{
                
                swch = SwitchItem(named: "卧室灯 \(strArray[3].toInt() ?? 0)", withWait: false, type:(2), andValue: 1)

            } else {
                
                swch = SwitchItem(named: "灯光 \(strArray[3].toInt() ?? 0)", withWait: false, type:(2), andValue: 1)

            }
            self.switches.append(swch)
            self.switches.sort({ (before , after) -> Bool in
                // add some sort
                
                return before.name < after.name ? true : false
            })
            self.switchDataHasUpdateDelegater?.switchDataHasUpdate()
        }
    }
    
    
}
