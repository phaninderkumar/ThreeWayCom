//
//  UIUpdater.swift
//  ThreeWay
//
//  Created by Phaninder Kumar on 06/10/21.
//

import Foundation
import ThreeWayXPCService
import ThreeWayCommon

class RemoteSupportUIUpdater {
    static let shared = RemoteSupportUIUpdater()
    var connectedToDaemon = false
    var coreDaemon: ThreeWayXPCServiceProtocol?
    var lastConnectionTriedAt: Double = 0
    

    func updateString(string: String) {
    }
    
    func getTime() {
        coreDaemon?.getCustomObject(withReply: { obj in
            print("obj: \(obj.displayTime)")
            self.coreDaemon?.processCustomObject(obj)
        })
    }

    func checkAndConnect() {
        guard shouldTryForConnection() else { return }
        guard !connectedToDaemon else {
//            logger.info("Already connected")
            return
        }
        connect()
    }
    
    private func shouldTryForConnection() -> Bool {
        if lastConnectionTriedAt == 0 {
            return true
        }
        return Date().timeIntervalSince1970 - lastConnectionTriedAt > 5
    }
    
    func connect() {
        lastConnectionTriedAt = Date().timeIntervalSince1970
        logger.info("called connect")

        let connection = NSXPCConnection(serviceName: "com.phaninderkumar.ThreeWayXPCService")
        let remoteObjectInterface = NSXPCInterface(with: ThreeWayXPCServiceProtocol.self)
        remoteObjectInterface.setClasses(NSSet(array: [NSNumber.self, TestObject.self]) as! Set<AnyHashable>, for: #selector(ThreeWayXPCServiceProtocol.getCustomObject(withReply:)), argumentIndex: 0, ofReply: true)

        connection.remoteObjectInterface = remoteObjectInterface
        
        connection.resume()
        coreDaemon = connection.synchronousRemoteObjectProxyWithErrorHandler { error in
            logger.info("Unable to connect to daemon: \(error)")
        } as? ThreeWayXPCServiceProtocol
        /* Try to checkin... forever! */
    }

}
