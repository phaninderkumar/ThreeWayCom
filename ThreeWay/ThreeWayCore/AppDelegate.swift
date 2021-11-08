//
//  AppDelegate.swift
//  ThreeWayCore
//
//  Created by Phaninder Kumar on 08/11/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private var globalTimer: Timer?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        logger.info("Core Launched and running")
        initializeTimer()
        
        
        let server = DaemonXPCServer()
        let listener = NSXPCListener(machServiceName: "com.phaninderkumar.ThreeWayCoreAnon")
        listener.delegate = server;
        listener.resume()
        logger.info("Daemon listening for agent connections")
        server.waitForConnection()
        logger.info("Creating agent remote object")
        let agent = server.agentResponder.connection!.synchronousRemoteObjectProxyWithErrorHandler { error in
            logger.error("Problem with the connection to the agent \(String(describing: error))")
        } as? TestAgentXPCProtocol
        logger.info("Making the agent to do some work!")
        agent!.doWork(task: "Work Work") { (reply) in
            if reply {
                logger.info("Work success!")
            } else {
                logger.info("Work fail!")
            }
        }
        logger.info("Daemon done")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        logger.info("Core Will terminate")
    }

    func initializeTimer() {
        logger.info("Initializing timer")
        guard globalTimer == nil else {
            return
        }
        globalTimer = Timer.scheduledTimer(timeInterval: 10,
                                           target: self,
                                           selector: #selector(timerFired),
                                           userInfo: nil,
                                           repeats: true)
        globalTimer?.fire()
    }

    @objc func timerFired() {
        logger.info("Timer fired")
    }


}

