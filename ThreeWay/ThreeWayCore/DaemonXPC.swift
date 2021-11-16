//
//  DaemonXPC.swift
//  ThreeWayCore
//
//  Created by Phaninder Kumar on 08/11/21.
//

import Foundation

@objc class AgentXPCConnector: NSObject, TestDaemonXPCProtocol{
    let connectionEstablished = DispatchSemaphore(value: 0)
    var connection: NSXPCConnection?
    func agentCheckIn(agentEndpoint: NSXPCListenerEndpoint, withReply reply: @escaping (Bool) -> Void) {
        if connection == nil {
            logger.info("Agent checking in")
            connection = NSXPCConnection(listenerEndpoint: agentEndpoint)
            connection!.remoteObjectInterface = NSXPCInterface(with: TestAgentXPCProtocol.self)
            connection!.resume()
            reply(true)
            connectionEstablished.signal()
        } else {
            logger.error("There is an agent alredy connected")
            reply(false)
        }
    }
    
    func getDateString(_ date: Date, reply: @escaping (String) -> Void) {
        logger.info("getDateString called")
        reply(date.getLocalStringDate())
    }
    
}

class DaemonXPCServer : NSObject, NSXPCListenerDelegate {
    let agentResponder = AgentXPCConnector()
    func waitForConnection() {
        let timeOut = DispatchTime.now() + DispatchTimeInterval.seconds(86400)
        switch agentResponder.connectionEstablished.wait(timeout: timeOut) {
        case .success:
            logger.info("Connection established")
        case .timedOut:
            logger.error("Timed out while waiting for connection")
            exit(1)
        }
    }
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        newConnection.exportedInterface = NSXPCInterface(with: TestDaemonXPCProtocol.self)
        newConnection.exportedObject = agentResponder
        newConnection.resume()
        return true
    }
}

