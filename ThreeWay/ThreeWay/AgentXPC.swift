//
//  AgentXPC.swift
//  ThreeWayXPCService
//
//  Created by Phaninder Kumar on 08/11/21.
//

import Foundation

@objc class AgentXPC: NSObject, TestAgentXPCProtocol{
    func doWork(task: String, withReply reply: @escaping (Bool) -> Void) {
        logger.info("Starting work")
        sleep(5)
        logger.info("Work DONE!")
        reply(true)
    }
}

class AgentAnonDelegate : NSObject, NSXPCListenerDelegate {
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        let exportedObject = AgentXPC()
        newConnection.exportedInterface = NSXPCInterface(with: TestAgentXPCProtocol.self)
        newConnection.exportedObject = exportedObject
        newConnection.resume()
        return true
    }
}
