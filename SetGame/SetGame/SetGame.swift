//
//  SetGame.swift
//  SetGame
//
//  Created by Yeh, Louis on 2018/5/7.
//  Copyright © 2018年 Yeh, Louis. All rights reserved.
//

import Foundation

struct SetGame {
    public static let numberOfFeatureType = Card.cardFeatureTypes.count
    public static let numberOfFeatureValue = FeatureValue.count
    public static let numberOfTotalCard = numberOfFeatureValue ^^ numberOfFeatureType
    public static let numberOfCardInASet = 3
    public static let numberOfCardOnBoardInitial = 12

    private var cards:[Card]
    public var cardsUnselected: [Int]
    public var cardsInDeck: [Int]
    public var cardsSelected: [Int]
    public var cardsMatched: [Int]

    var acceptableBitwiseValues: [Int] {
        get {
        var result = (0..<SetGame.numberOfFeatureValue).map { FeatureValue(rawValue: $0)!.bitwise }
            result.append(result.reduce (0) { $0 | $1 })
            return result
        }
    }
    func isSet(cards: [Card]) -> Bool {
        guard (SetGame.numberOfCardInASet == cards.count) else {
            return false
        }
        return Card.cardFeatureTypes.map { (n) -> [Feature] in cards.map { $0.cardFeatures.filter { $0.type == n }.first! } }.reduce (true) { $0 || acceptableBitwiseValues.contains($1.reduce (0) { $0 | $1.value.bitwise }) }
    }

    init() {
        cards = [Card]()
        (cardsInDeck, cardsUnselected, cardsSelected, cardsMatched) = ([], [], [], [])
        prepareAllCards(type: 0, value: 0, featuresBucket: [Feature](), deck: &cards)
        cardsInDeck = Array(cards.indices)
        for _ in 0..<SetGame.numberOfCardOnBoardInitial {
            if let rendomCard = cardsInDeck.draw() {
                cardsUnselected.append(rendomCard)
            }
        }
    }

    public func prepareAllCards(type: Int, value: Int, featuresBucket: [Feature], deck: inout [Card]) {
        guard (type < SetGame.numberOfFeatureType) else {
            if let newCard = Card(features: featuresBucket) {
                deck.append(newCard)
            }
            return
        }
        for featureValue in 0..<SetGame.numberOfCardInASet {
            var nextLevelBucket = featuresBucket
            if let newFeatureValue = FeatureValue(rawValue: featureValue) {
                nextLevelBucket.append(Feature(type: Card.cardFeatureTypes[type], value: newFeatureValue))
            }
            prepareAllCards(type: type + 1, value: featureValue, featuresBucket: nextLevelBucket, deck: &deck)
        }
    }
}

extension FeatureValue {
    public var bitwise:Int {
        get {
            return 2 ^^ self.rawValue
        }
    }
}

extension Array {
    public mutating func draw() -> Element? {
        guard (self.count > 0) else {
            return nil
        }
        return self.remove(at: Int(arc4random_uniform(UInt32(self.count))))
    }
}

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}
