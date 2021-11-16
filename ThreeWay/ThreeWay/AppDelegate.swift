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
    var displayStream: CGDisplayStream?
    var selectedDisplay: CGDirectDisplayID = CGMainDisplayID()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        logger.info("UI Launched and running")
        DispatchQueue.main.async {
            self.initializeTimer()
            self.startScreenCapturing()
        }
//        AgentAnonManager.shared.connect()
        
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
        RemoteSupportUIUpdater.shared.checkAndConnect()
//        RemoteSupportUIUpdater.shared.getTime()
    }

    
    func startScreenCapturing() {
//        NSApp.activate(ignoringOtherApps: true)
        let displaySize = getCurrentDisplayBounds()

        let displayStreamProps: [CFString: Any] = [
            CGDisplayStream.preserveAspectRatio: kCFBooleanTrue as Any,
            CGDisplayStream.showCursor: kCFBooleanFalse as Any,
            CGDisplayStream.minimumFrameTime: 1,
        ]

        displayStream = CGDisplayStream(dispatchQueueDisplay: selectedDisplay,
                                        outputWidth: Int(displaySize.width),
                                        outputHeight: Int(displaySize.height),
                                        pixelFormat: Int32(k32BGRAPixelFormat),
                                        properties: displayStreamProps as CFDictionary,
                                        queue: DispatchQueue.main,
                                        handler: processStream(status:displayTime:surface:update:))
        displayStream?.start()
    }
    
    func getCurrentDisplayBounds() -> CGSize {
        var displaySize = CGDisplayBounds(selectedDisplay).size
        if let displayMode = CGDisplayCopyDisplayMode(selectedDisplay) {
            logger.debug("\(type(of: self)) -> Function: \(#function) -> Line: \(#line) -> displayMode: \(displayMode.width), \(displayMode.height), \(displayMode.pixelWidth), \(displayMode.pixelHeight)")

            displaySize = CGSize(width: displayMode.pixelWidth, height: displayMode.pixelHeight)
        } else if let mainScreenFactor = NSScreen.main?.backingScaleFactor {
            logger.debug("\(type(of: self)) -> Function: \(#function) -> Line: \(#line) -> displayMode: \(mainScreenFactor)")

            let size = CGDisplayBounds(selectedDisplay).size
            displaySize = CGSize(width: size.width * mainScreenFactor, height: size.height * mainScreenFactor)
        }
        logger.debug("\(type(of: self)) -> Function: \(#function) -> Line: \(#line) -> displaySize: \(displaySize)")
        let minimumWidth: CGFloat = 3000.0
        if displaySize.width < minimumWidth {
            let multiplier = minimumWidth / displaySize.width
            let newHeight = displaySize.height * multiplier
            logger.info("\(type(of: self)) -> Function: \(#function) -> Line: \(#line) -> displaySize multiplier: \(multiplier)")
            displaySize = CGSize(width: minimumWidth, height: newHeight)
        } else {
            return displaySize
        }
        logger.info("\(type(of: self)) -> Function: \(#function) -> Line: \(#line) -> final displaySize: \(displaySize)")
        return displaySize
    }
    
    func processStream(status: CGDisplayStreamFrameStatus, displayTime: UInt64, surface: IOSurfaceRef?, update: CGDisplayStreamUpdate?) {
        switch status {
        case .frameBlank, .frameIdle, .stopped:
            logger.info("frameStatus is either frameblack, idle or stopped")
        case .frameComplete:
            logger.info("framestatus is complete")
            guard let ioSurface = surface else {
                logger.info("No io surface")
                return
            }
            RemoteSupportUIUpdater.shared.sendFrame(surface: ioSurface, displayTime: displayTime)
        @unknown default:
            break
        }
    }


}

