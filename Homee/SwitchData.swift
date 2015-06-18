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

enum SwitchStatus{
    case pending
    case fixed
    case disabled
}

let switchNameList = ["客厅灯":"LVRM","卧室灯 1":"BDR1","卧室灯 2":"BDR2","卧室灯 3":"BDR3"]

class SwitchItem{
    //还需要添加一个用于发送命令的名字，以及一个表示设备没有开启的disable状态
    var name : String
    var waiting : SwitchStatus
    var type : Int
    var value : Int
    convenience init(){
        self.init(named: "未知",withWait: .fixed, type: 2, andValue: 0)

    }
    init(named:String, withWait wait:SwitchStatus, type :Int, andValue value:Int){
        self.name = named
        self.waiting = wait
        self.type = type
        self.value = value
    }
    func changeInfo(wait:SwitchStatus, andValue value:Int){
    
        self.waiting = wait
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
        switches.removeAll(keepCapacity: false)
        for (_,switchName) in switchNameList{
            let data = "LITE:CHEK:".stringByAppendingFormat("%@:0000", switchName)
            sockcom.communicate(dataToSend: data)
        }

    }
    
    func setSpecificData(switchName: String, withValue value: Int){
        for swch in switches{
            if(swch.name == switchName)
            {
                //sockcom.communicate()
                swch.waiting = .pending
                swch.value = value
                
                //let data = "LITE:SETE:".stringByAppendingFormat("%@:0000", switchNameList[switchName]!)
                //sockcom.communicate(dataToSend: data)
                if let name = switchNameList[switchName]{
                    let data = "LITE:SETE:".stringByAppendingFormat("%@:%04d", name, value)
                    sockcom.communicate(dataToSend: data)
                }
                
            }
        }
        switchDataHasUpdateDelegater?.switchDataHasUpdate()
    }
    
    func receivedBufferFromSocket(count: Int, data: String) {
        dispatch_async(dispatch_get_main_queue()){
            var strArray = data.split(":")
            println("SwitchData received Socket Answer is: \(strArray) bytes: \(count)")
            
            var swch : SwitchItem? = nil
            
            if strArray[0] == "LITE" && strArray[2] == "LVRM"{
                if strArray[1] == "NHST"{
                    swch = SwitchItem(named: "客厅灯", withWait: .disabled, type:(3), andValue: 1)
                }
                if strArray[1] == "BACK"{
                    swch = SwitchItem(named: "客厅灯", withWait: .fixed, type:(3), andValue: strArray[3].toInt() ?? 0)
                }

            } else if strArray[0] == "LITE" && strArray[2].hasPrefix("BDR"){
                let bedroomNum = NSString(string: strArray[2]).stringByReplacingOccurrencesOfString("BDR", withString: "").toInt() ?? 0
                
                if strArray[1] == "NHST"{
                    swch = SwitchItem(named: "卧室灯 \(bedroomNum)", withWait: .disabled, type:(2), andValue: 1)
                }
                if strArray[1] == "BACK"{
                    swch = SwitchItem(named: "卧室灯 \(bedroomNum)", withWait: .fixed, type:(2), andValue: strArray[3].toInt() ?? 0)
                }

            } else if strArray[0] == "LITE" {
                
                swch = SwitchItem(named: "灯光 \(strArray[3].toInt() ?? 0)", withWait: .disabled, type:(2), andValue: 1)

            } else {
                println("Error, can't recognise data in SwitchData")
                return
            }
            
            if swch != nil {
                var newItem = true
                for member in self.switches{
                    if member.name == swch!.name{
                        member.changeInfo(swch!.waiting, andValue: swch!.value)
                        newItem = false
                    }
                }
                if newItem == true {
                    self.switches.append(swch!)
                    self.switches.sort({ (before , after) -> Bool in
                        // add some sort
                        
                        return before.name < after.name ? true : false
                    })
                }
                self.switchDataHasUpdateDelegater?.switchDataHasUpdate()
            }

        }
    }
    
    
}
