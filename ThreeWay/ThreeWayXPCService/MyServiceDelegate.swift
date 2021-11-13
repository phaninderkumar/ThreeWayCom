//
//  MyServiceDelegate.Swift
//  ThreeWayXPCService
//
//  Created by Phaninder Kumar on 08/11/21.
//

import Foundation

class ThreeWayXPCServiceDelegate: NSObject, NSXPCListenerDelegate {
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        let exportedObject = ThreeWayXPCService()
        let exportedInterface = NSXPCInterface(with: ThreeWayXPCServiceProtocol.self)
//        exportedInterface.setClasses(NSSet(array: [TestObject.self]) as! Set<AnyHashable>, for: #selector(ThreeWayXPCServiceProtocol.getCustomObject(withReply:)), argumentIndex: 0, ofReply: true)

        newConnection.exportedInterface = exportedInterface
        newConnection.exportedObject = exportedObject
        newConnection.resume()
        return true
    }
}
