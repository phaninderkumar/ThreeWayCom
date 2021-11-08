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


}

