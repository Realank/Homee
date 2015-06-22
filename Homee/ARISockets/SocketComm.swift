//
//  SocketComm.swift
//  Homee
//
//  Created by Realank-Mac on 15/4/5.
//  Copyright (c) 2015年 Realank-Mac. All rights reserved.
//

import UIKit

protocol receiveSocketMsgDelegate{
    func receivedBufferFromSocket(count:Int, data: String)
}

struct IPAndPort {
    static var hostIP = "182.92.183.168"
    static var port = 3001
}

class SocketComm: NSObject {
    
    var receiverDelegater : receiveSocketMsgDelegate?
    let queue = dispatch_queue_create("SocketComm",DISPATCH_QUEUE_CONCURRENT)
    
    func communicate(dataToSend data: String){
        dispatch_async(queue){
            self.communicateAsync(dataToSend: data)
        }
    }
    
    func communicateAsync(dataToSend : String? = nil){
        
        var socket : ActiveSocketIPv4? = ActiveSocket<sockaddr_in>()
        println("Got socket: \(socket)")
        if socket == nil {
            return
        }
        
        socket?.onRead  { (ActiveSocket, Int) -> Void in
            let (count, block, errno) = ActiveSocket.read()
            if count < 0 && errno == EWOULDBLOCK {
                return
            }
            if count < 1 {
                println("EOF, or great error handling \(errno).")
                socket?.close()
                return
            }
            var dataReceived = String.fromCString(block)!
            dataReceived = dataReceived.trim()
//            println("Socket Answer is: \(count) bytes: \(dataReceived)")
            //usleep(3000000)
            self.receiverDelegater?.receivedBufferFromSocket(dataReceived.length(), data: dataReceived)
            socket?.close()
            
        }
        

        socket?.onClose { fd in println("Closing \(fd) ..."); }
        
        // connect

        println("Connect \(IPAndPort.hostIP):\(IPAndPort.port) ...")
        
        let ok = socket?.connect(sockaddr_in(address:IPAndPort.hostIP, port:IPAndPort.port)) {
            println("connected \(socket)")
            socket?.isNonBlocking = true
            
            if let sk = socket{
                sk.write( dataToSend ?? "WTHR:CHEK:WEEK:0000" )

            }
        }
        
        if (ok == nil) {
            println("connect failed \(socket)")
            socket?.close()
            socket = nil
        }

    }

}
