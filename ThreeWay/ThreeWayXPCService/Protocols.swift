//
//  Protocols.swift
//  ThreeWay
//
//  Created by Phaninder Kumar on 08/11/21.
//

import Foundation
@objc(TestDaemonXPCProtocol) protocol TestDaemonXPCProtocol {
    func agentCheckIn(agentEndpoint: NSXPCListenerEndpoint,
                      withReply reply: @escaping (Bool) -> Void)
    func getDateString(_ date: Date, reply: @escaping (String) -> Void)
}
@objc(TestAgentXPCProtocol) protocol TestAgentXPCProtocol {
  func doWork(task: String, withReply reply: @escaping (Bool) -> Void)
}
