//
//  ThreeWayXPCServiceProtocol.swift
//  ThreeWayXPCService
//
//  Created by Phaninder Kumar on 08/11/21.
//

import Foundation
import ThreeWayCommon

@objc public protocol ThreeWayXPCServiceProtocol {
    func upperCaseString(_ string: String, withReply reply: @escaping (String) -> Void)
    func getTime(withReply reply: @escaping (Date) -> Void)
    func getCustomObject(withReply reply: @escaping(TestObject) -> Void)
}
