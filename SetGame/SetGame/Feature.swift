//
//  FeatureType.swift
//  SetGame
//
//  Created by Yeh, Louis on 2018/5/7.
//  Copyright © 2018年 Yeh, Louis. All rights reserved.
//

import Foundation

enum FeatureValue: Int {
    case valueA = 0
    case valueB, valueC
    public static var count: Int {
        get {
            var max = 0
            while let _ = FeatureValue(rawValue: max) { max += 1 }
            return max
        }
    }
}

enum FeatureType {
    case color, number, shape, shade
}

struct Feature {
    public let type: FeatureType
    public let value: FeatureValue
}
