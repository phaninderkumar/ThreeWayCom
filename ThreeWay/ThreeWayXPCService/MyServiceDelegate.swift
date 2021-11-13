//
//  MyServiceDelegate.Swift
//  ThreeWayXPCService
//
//  Created by Phaninder Kumar on 08/11/21.
//

import Foundation
import ThreeWayCommon

class ThreeWayXPCServiceDelegate: NSObject, NSXPCListenerDelegate {
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        let exportedObject = ThreeWayXPCService()
        let exportedInterface = NSXPCInterface(with: ThreeWayXPCServiceProtocol.self)
        exportedInterface.setClasses(NSSet(array: [NSNumber.self, TestObject.self]) as! Set<AnyHashable>, for: #selector(ThreeWayXPCServiceProtocol.processCustomObject(_:)), argumentIndex: 0, ofReply: false)

        newConnection.exportedInterface = exportedInterface
        newConnection.exportedObject = exportedObject
        newConnection.resume()
        return true
    }
}
