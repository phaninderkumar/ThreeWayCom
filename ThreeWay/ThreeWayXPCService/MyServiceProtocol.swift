//
//  ThreeWayXPCServiceProtocol.swift
//  ThreeWayXPCService
//
//  Created by Phaninder Kumar on 08/11/21.
//

import Foundation

@objc public protocol ThreeWayXPCServiceProtocol {
    func upperCaseString(_ string: String, withReply reply: @escaping (String) -> Void)
}