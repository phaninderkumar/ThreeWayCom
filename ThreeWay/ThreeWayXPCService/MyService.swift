//
//  ThreeWayXPCService.swift
//  ThreeWayXPCService
//
//  Created by Phaninder Kumar on 08/11/21.
//

import Foundation
import ThreeWayCommon

class ThreeWayXPCService: NSObject, ThreeWayXPCServiceProtocol {
    func upperCaseString(_ string: String, withReply reply: @escaping (String) -> Void) {
        let response = string.uppercased()
        reply(response)
    }
    
    func getTime(withReply reply: @escaping (Date) -> Void) {
        let date = Date()
        reply(date)
    }
    
    func getCustomObject(withReply reply: @escaping (TestObject) -> Void) {
        logger.info("Sending custom object")
        let obj = TestObject(displayTime: Int.random(in: 0..<6))
        reply(obj)
    }

    func processCustomObject(_ obj: TestObject) {
        logger.info("received custom object: \(obj.displayTime)")

    }
    
}
