//
//  Card.swift
//  SetGame
//
//  Created by Yeh, Louis on 2018/5/7.
//  Copyright © 2018年 Yeh, Louis. All rights reserved.
//

import Foundation

struct Card {
    public let cardFeatures: [Feature]
    static let cardFeatureTypes: [FeatureType] = [.color, .number, .shape, .shade]
    public var cardPatternString: NSMutableAttributedString {
        get {
            let outputString = NSMutableAttributedString(string: "")
            return cardFeatures.map { (n) -> FeatureProtocol in createFeature(with: n) }.reduce(outputString)  { $1.applyFeature(to: $0) }
        }
    }
    init? (features: [Feature]) {
        guard (features.count == Card.cardFeatureTypes.count) else {
            return nil
        }
        guard (zip(Card.cardFeatureTypes, features).map { $0.0 == $0.1.type }.reduce(true) { $0 && $1 }) else {
            return nil
        }
        self.cardFeatures = features
    }
    func createFeature (with feature: Feature) -> FeatureProtocol{
        switch feature.type {
        case .color:
            return ColorFeature(with: feature)
        case .number:
            return NumberFeature(with: feature)
        case .shade:
            return ShadeFeature(with: feature)
        case .shape:
            return ShapeFeature(with: feature)
        }
    }
}
