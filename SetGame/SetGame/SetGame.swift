//
//  SetGame.swift
//  SetGame
//
//  Created by Yeh, Louis on 2018/5/7.
//  Copyright © 2018年 Yeh, Louis. All rights reserved.
//

import Foundation

struct SetGame {
    let numberOfFeatureType = 4
    let numberOfFeatureValue = FeatureValue.count
    let numberOfTotalCard = 3 ^^ 4
    let numberOfCardInASet = 3
    var acceptableBitwiseValues:[Int] {
        get {
        var result = (0..<numberOfFeatureValue).map { FeatureValue(rawValue: $0)!.bitwise }
            result.append(result.reduce (0) { $0 | $1 })
            return result
        }
    }
    func isSet(cards: [Card]) -> Bool {
        guard (numberOfCardInASet == cards.count) else {
            return false
        }
        return Card.cardFeatureTypes.map { (n) -> [Feature] in cards.map { $0.cardFeatures.filter { $0.type == n }.first! } }.reduce (true) { $0 || acceptableBitwiseValues.contains($1.reduce (0) { $0 | $1.value.bitwise }) }
    }

}

extension FeatureValue {
    public var bitwise:Int {
        get {
            return 2 ^^ self.rawValue
        }
    }
}

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}
