//
//  TestObject.swift
//  ThreeWay
//
//  Created by Phaninder Kumar on 13/11/21.
//

import Foundation

@objc(TestObject) public class TestObject: NSObject, NSSecureCoding {
    
    public let displayTime: Int

    private enum CodingKeys: String {
        case displayTime
    }

    public static var supportsSecureCoding: Bool { true }

    public func encode(with coder: NSCoder) {
        coder.encode(displayTime, forKey: CodingKeys.displayTime.rawValue)
    }

    public required init?(coder: NSCoder) {
        self.displayTime = coder.decodeObject(forKey: CodingKeys.displayTime.rawValue) as? Int ?? 0
    }

    public init(displayTime: Int) {
        self.displayTime = displayTime
    }
}
