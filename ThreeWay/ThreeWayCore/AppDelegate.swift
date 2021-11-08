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

