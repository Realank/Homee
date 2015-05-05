//
//  SettingViewController.swift
//  Homee
//
//  Created by Realank-Mac on 15/4/7.
//  Copyright (c) 2015年 Realank-Mac. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController,receiveSocketMsgDelegate {
    
    let sockcom = SocketComm()

    @IBOutlet weak var ip: UITextField!
    @IBOutlet weak var port: UITextField!
    @IBOutlet weak var command: UITextField!
    @IBOutlet weak var result: UITextView!
    @IBAction func clear(sender: UIButton) {
        result.text = ""
    }
    
    @IBAction func setHost(sender: UIButton) {
        IPAndPort.hostIP = ip.text
        IPAndPort.port = port.text.toInt() ?? 6001
        
    }

    
    @IBAction func sendCmd(sender: UIButton) {
        sockcom.communicate(dataToSend: command.text.trim())
    }
    
    func receivedBufferFromSocket(count: Int, data: String) {
        dispatch_async(dispatch_get_main_queue()){
            println("settingview received Socket Answer is: \(data) bytes: \(count)")
            self.result.text = self.result.text + "\(data)\n"

        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        println("touchesBegan")
        
        //let touchesSet=touches as NSSet                  altnate ways
        //let touch=touchesSet.anyObject() as? UITouch
        let touch = touches.first as? UITouch
        
        if let view = touch?.view
        {
            if ip.isFirstResponder() == true && view != ip{
                ip.resignFirstResponder()
            }
            if port.isFirstResponder() == true && view != port{
                port.resignFirstResponder()
            }
            if command.isFirstResponder() == true && view != command{
                command.resignFirstResponder()
            }
        }else{
            println("touch view is nil")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sockcom.receiverDelegater = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
