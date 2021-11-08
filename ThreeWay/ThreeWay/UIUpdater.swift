//
//  UIUpdater.swift
//  ThreeWay
//
//  Created by Phaninder Kumar on 06/10/21.
//

import Foundation
import ThreeWayXPCService

class RemoteSupportUIUpdater {
    static let shared = RemoteSupportUIUpdater()
    
    func updateString(string: String) {
        let connection = NSXPCConnection(serviceName: "com.phaninderkumar.ThreeWayXPCService")
        connection.remoteObjectInterface = NSXPCInterface(with: ThreeWayXPCServiceProtocol.self)
        connection.resume()

        let service = connection.remoteObjectProxyWithErrorHandler { error in
            print("Received error:", error)
        } as? ThreeWayXPCServiceProtocol

        service?.upperCaseString("hello XPC") { response in
            print("Response from XPC service:", response)
        }
    }
    
    func getTime() {
        let connection = NSXPCConnection(serviceName: "com.phaninderkumar.ThreeWayXPCService")
        connection.remoteObjectInterface = NSXPCInterface(with: ThreeWayXPCServiceProtocol.self)
        connection.resume()

        let service = connection.remoteObjectProxyWithErrorHandler { error in
            print("Received error:", error)
        } as? ThreeWayXPCServiceProtocol
        service?.getTime(withReply: { response in
            AgentAnonManager.shared.getConvertedDate(response) { response in
                let userInfo = ["response": response]
                NotificationCenter.default.post(name: NSNotification.Name("TimeUpdated"), object: self, userInfo: userInfo)

            }
        })
    }

}
