//
//  OSLogExtension.swift
//  RemoteCast
//
//  Created by Phaninder Kumar on 21/04/21.
//

import Foundation
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like viewDidLoad.
    static let viewCycle = OSLog(subsystem: subsystem, category: "viewcycle")
}
