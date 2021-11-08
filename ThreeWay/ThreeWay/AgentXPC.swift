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

class AgentAnonManager {
    
    static let shared = AgentAnonManager()
    var connectedToDaemon = false
    var daemon: TestDaemonXPCProtocol?
    
    func connect() {
        logger.info("called doSomethingElse")

        /* Prepare Anonymous listenter endpoint */
        let anonDelegate = AgentAnonDelegate()
        let anonListener = NSXPCListener.anonymous()
        anonListener.delegate = anonDelegate
        anonListener.resume()
        let anonEndpoint = anonListener.endpoint
        /* Prepare connection to the daemon */
        let daemonConnection = NSXPCConnection(machServiceName: "com.phaninderkumar.ThreeWayCoreAnon", options: NSXPCConnection.Options.privileged)
        daemonConnection.remoteObjectInterface = NSXPCInterface(with: TestDaemonXPCProtocol.self)
        daemonConnection.resume()
        daemon = daemonConnection.synchronousRemoteObjectProxyWithErrorHandler { error in
            logger.info("Unable to connect to daemon: \(error)")
        } as? TestDaemonXPCProtocol
        /* Try to checkin... forever! */
        connectedToDaemon = false
        while !connectedToDaemon {
            daemon!.agentCheckIn(agentEndpoint: anonEndpoint) { (reply) in
                logger.info("Passed endpoint to the deamon")
                self.connectedToDaemon = true
            }
            sleep(10)
        }
        /* Nothing more to do here. Only doing work for the daemon */
        logger.info("Agent is in the work loop")
    }
    
    func getConvertedDate(_ date: Date, reply: @escaping (String) -> Void) {
        logger.info("is connectedToDaemon: \(connectedToDaemon) with daemon: \(daemon)")
        daemon?.getDateString(date, reply: { dateString in
            logger.info("Returning converted date: \(dateString)")
            reply(dateString)
        })
    }
    
}
