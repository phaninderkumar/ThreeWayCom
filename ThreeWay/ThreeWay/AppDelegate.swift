//
//  AppDelegate.swift
//  ThreeWay
//
//  Created by Phaninder Kumar on 06/10/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private var globalTimer: Timer?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        logger.info("UI Launched and running")
        initializeTimer()
        logger.info("calling doSomethingElse")

        doSomethingElse()

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        logger.info("UI will terminate")
    }
    
    func initializeTimer() {
        logger.info("Initializing timer")
        guard globalTimer == nil else {
            return
        }
        globalTimer = Timer.scheduledTimer(timeInterval: 1,
                                           target: self,
                                           selector: #selector(timerFired),
                                           userInfo: nil,
                                           repeats: true)
        globalTimer?.fire()
    }

    @objc func timerFired() {
        RemoteSupportUIUpdater.shared.getTime()
    }


    func doSomethingElse() {
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
        let daemon = daemonConnection.synchronousRemoteObjectProxyWithErrorHandler { error in
            logger.info("Unable to connect to daemon: \(error)")
        } as? TestDaemonXPCProtocol
        /* Try to checkin... forever! */
        var connectedToDaemon = false
        while !connectedToDaemon {
            daemon!.agentCheckIn(agentEndpoint: anonEndpoint) { (reply) in
                logger.info("Passed endpoint to the deamon")
                connectedToDaemon = true
            }
            sleep(10)
        }
        /* Nothing more to do here. Only doing work for the daemon */
        logger.info("Agent is in the work loop")
    }

}

