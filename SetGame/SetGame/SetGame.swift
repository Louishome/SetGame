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

    private var _cardsUnselected: [Int]
    private var _cardsInDeck: [Int]
    private var _cardsSelected: [Int]
    private var _cardsMatched: [Int]

    public let cards:[Card]
    public var cardsUnselected: [Int] { get { return _cardsUnselected } }
    public var cardsInDeck: [Int] { get { return _cardsInDeck } }
    public var cardsSelected: [Int] { get { return _cardsSelected } }
    public var cardsMatched: [Int] { get { return _cardsMatched } }

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
        return Card.cardFeatureTypes.map { (n) -> [Feature] in cards.map { $0.cardFeatures.filter { $0.type == n }.first! } }.reduce (true) { $0 && acceptableBitwiseValues.contains($1.reduce (0) { $0 | $1.value.bitwise }) }
    }

    init(with numberOfCards: Int) {
        var tempCards = [Card]()
        SetGame.prepareAllCards(type: 0, value: 0, featuresBucket: [Feature](), deck: &tempCards)
        cards = tempCards
        (_cardsInDeck, _cardsUnselected, _cardsSelected, _cardsMatched) = ([], [], [], [])
        _cardsInDeck = Array(cards.indices)
        for _ in 0..<numberOfCards {
            if let randomCard = _cardsInDeck.draw() {
                _cardsUnselected.append(randomCard)
            }
        }
    }
    public mutating func draw3Cards() -> [Int] {
        checkSelectedCards()
        var drawnCardIndexes = [Int]()
        for _ in 0..<3 {
            if let randomCard = _cardsInDeck.draw() {
                _cardsUnselected.append(randomCard)
                drawnCardIndexes.append(randomCard)
            }
        }
        return drawnCardIndexes
    }
    private mutating func checkSelectedCards() -> Void {
        guard _cardsSelected.count <= SetGame.numberOfCardInASet else {
            print("Error: more than \(SetGame.numberOfCardInASet) cards seleted, will unselect them.")
            _cardsSelected.moveAll(to: &_cardsUnselected)
            return
        }
        guard _cardsSelected.count == SetGame.numberOfCardInASet else {
            return
        }
        if isSet(cards: _cardsSelected.map { cards[$0] }) {
            _cardsSelected.moveAll(to: &_cardsMatched)
        } else {
            _cardsSelected.moveAll(to: &_cardsUnselected)
        }
    }

    public mutating func selectCard(of cardIndex:Int) {
        guard !_cardsMatched.contains(cardIndex) else {
            print("Error: selected a matched card.")
            return
        }
        guard !_cardsSelected.contains(cardIndex) else {
            _cardsSelected.move(this: cardIndex, to: &_cardsUnselected)
            return
        }
        guard cardsUnselected.contains(cardIndex) else {
            print("Error: cannot find this card id in unslected cards.")
            return
        }
        checkSelectedCards()
        _cardsUnselected.move(this: cardIndex, to: &_cardsSelected)
    }

    static private func prepareAllCards(type: Int, value: Int, featuresBucket: [Feature], deck: inout [Card]) {
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
extension Array where Element: Equatable {
    public mutating func move(this element:Element ,to anotherArray: inout [Element]) -> Void {
        guard let indexOfElement = self.index(of: element) else {
            print("Error: unable to move this element, because it is not in this array.")
            return
        }
        anotherArray.append(self.remove(at: indexOfElement))
    }
    public mutating func moveAll(to anotherArrey: inout [Element]) -> Void {
        while let firstElement = self.first {
            self.move(this: firstElement, to: &anotherArrey)
        }
    }
}

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}
